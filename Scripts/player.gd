class_name Player extends CharacterBody3D
## Main player script.
##
## Handles movement of the player. Has a [Hotbar] which can contain [Item] nodes
## that the player may use.


## Signals when [member raycast_hit] changes.
signal raycast_hit_changed(raycast_hit: Object)


@export_category("Acceleration Values")
## Horizontal movement acceleration when on the ground (m/s^2).
@export var acceleration: float = 100.0
## Horizontal movement acceleration when in the air (m/s^2).
@export var air_acceleration: float = 5.0

@export_category("Movement Speeds")
## Regular walk speed for horizontal movement (m/s).
@export var walk_speed: float = 4.0
## Faster run speed for horizontal movement (m/s).
@export var run_speed: float = 8.0
## Vertical speed to set when the player jumps, affects how high the player can jump (m/s).
@export var jump_speed: float = 5.0
## Maximum speed at which the player may fall vertically (m/s).
@export var max_fall_speed: float = 75.0

@export_category("Head Bob Values")
## How fast to accelerate the camera bob height (m/s^2). May limit the maximum
## effective amplitude if set too low. Camera will jump quickly if set too high.
@export var camera_bob_acceleration: float = 1.0
## Frequency of walk bob (cycles/s).
@export var walk_bob_frequency: float = 1.5
## Amplitude of walk bob (m).
@export var walk_bob_amplitude: float = 0.08
## Frequency of run bob (cycles/s).
@export var run_bob_frequency: float = 2.0
## Ampluitude of run bob (m).
@export var run_bob_amplitude: float = 0.08

## [Object] currently hit by the player's raycast, or null if no object is hit.
var raycast_hit: Object = null

# Value between 0 and 1 representing the progress along a cycle of the bob sine wave
var _bob_progress: float = 0.0
# Stores pending camera rotation
var _pending_camera_rotation := Vector2.ZERO
# Boolean controlling which movement speed to use.
var _running: bool = false
# Current walk velocity (only x and z)
var _walk_velocity := Vector3.ZERO
# Current vertical velocity due to gravity/jumping (only y)
var _vertical_velocity := Vector3.ZERO

@onready var _camera: Camera3D = $CameraOffset/Camera3D
@onready var _raycast: RayCast3D = $CameraOffset/Camera3D/RayCast3D
@onready var _hotbar: Hotbar = $Hotbar


#region Built-in Function Overrides
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		interact()
	
	if event.is_action_pressed(&"drop"):
		drop_item()
	
	if event.is_action_pressed(&"select_next_hotbar_slot"):
		_hotbar.increment_selected_index()
		_update_raycast_hit()
	
	if event.is_action_pressed(&"select_previous_hotbar_slot"):
		_hotbar.decrement_selected_index()
		_update_raycast_hit()
	
	# Toggle running when pressing/releasing run
	if event.is_action_pressed(&"run"):
		_running = true
	if event.is_action_released(&"run"):
		_running = false
	
	# Handle rotation of camera due to moues movement
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_pending_camera_rotation.x -= event.screen_relative.y * 0.002
		_pending_camera_rotation.y -= event.screen_relative.x * 0.002
	
	# TODO: this should be handled in a world level script
	if event.is_action_pressed(&"pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta: float) -> void:
	# Update camera height and rotation
	_update_camera_motion(delta)
	# Update horizontal and vertical velocity and apply movement
	self.velocity = _get_walk_velocity(delta) + _get_vertical_velocity(delta)
	move_and_slide()
	# Update raycast
	_update_raycast_hit()
#endregion


# Updates the raycast hit object after the player's raycast is updated.
func _update_raycast_hit() -> void:
	# The object that is colliding or null if no object is colliding
	var new_raycast_hit: Object = _raycast.get_collider()
	if new_raycast_hit != self.raycast_hit:
		# Update object highlights
		if self.raycast_hit is Interactible:
			self.raycast_hit.unhighlight()
		if new_raycast_hit is Interactible:
			new_raycast_hit.highlight(_hotbar.selected_item)
		
		# Update the raycasts
		self.raycast_hit = new_raycast_hit
		raycast_hit_changed.emit(new_raycast_hit)


#region Player Motion
# Updates walk velocity by reading player input and accelerating walk velocity
# towards the player's inputted velocity. Acceleration depends on whether the
# player is on the floor or in the air.
func _get_walk_velocity(delta: float) -> Vector3:
	# Get input and set walk direction
	var walk_input := Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_back")
	var walk_direction = _camera.transform.basis * Vector3(walk_input.x, 0, walk_input.y)
	walk_direction = (walk_direction * Vector3(1, 0, 1)).normalized()
	# Update walk velocity using walk/run speed and ground/air acceleration
	_walk_velocity = _walk_velocity.move_toward(
			walk_direction * (run_speed if _running else walk_speed),
			(acceleration if is_on_floor() else air_acceleration) * delta)
	
	return _walk_velocity


# Updates the vertical velocity by applying gravity. Reads input to check if the
# player wants to jump, only applies a jump if on the floor.
func _get_vertical_velocity(delta: float) -> Vector3:
	# Apply jump if the player just jumped
	if is_on_floor() and Input.is_action_just_pressed(&"jump"):
		_vertical_velocity = Vector3.UP * jump_speed
	elif is_on_floor():
		_vertical_velocity = Vector3.ZERO
	# Apply gravity to the vertical velocity
	_vertical_velocity += get_gravity() * delta
	# Clamp the vertical velocity to the max fall speed
	_vertical_velocity.y = clampf(_vertical_velocity.y, -max_fall_speed, INF)
	
	return _vertical_velocity
#endregion


#region Camera Motion
# Updates the camera motion by applying head bob motion and rotation.
func _update_camera_motion(delta: float) -> void:
	_update_camera_bob(delta)
	_update_camera_rotation()


# Updates the camera height to create an up/down bob motion when the player is
# moving. Resets the camera height to 0 when the player is still or falling.
func _update_camera_bob(delta: float) -> void:
	# Target y offset for camera bob
	var target_bob_offset: float = 0.0
	
	# Update bob progress and override the target bob if moving
	if is_on_floor() and _is_moving_horizontally():
		var frequency = (run_bob_frequency if _running else walk_bob_frequency)
		_bob_progress = fmod(_bob_progress + delta * frequency, 1.0)
		var amplitude = (run_bob_amplitude if _running else walk_bob_amplitude)
		target_bob_offset = amplitude * sin(_bob_progress * TAU)
	else:
		_bob_progress = 0.0 # reset if not moving or in the air
	
	# Move the camera bob closer to the target value and update the position
	_camera.position.y = move_toward(_camera.position.y, target_bob_offset,
			camera_bob_acceleration * delta)


# Resolves pending rotation by applying it to the camera rotation property.
func _update_camera_rotation() -> void:
	# Clamp vertical rotation to a min/max
	_camera.rotation.x = clampf(_camera.rotation.x + _pending_camera_rotation.x, -1.5, 1.5)
	# Also update hotbar rotation to match camera
	_camera.rotation.y += _pending_camera_rotation.y
	# Reset pending rotation to zero
	_pending_camera_rotation = Vector2.ZERO


# Returns true if the player is moving horizontally (may be in the air or on the ground).
func _is_moving_horizontally() -> bool:
	return _walk_velocity.length() > 0
#endregion


## Performs an interact action when the player presses the interact button.
## Tries interacting with a hand interactible object first, then tries
## using the tool in the player's hand.
func interact() -> void:
	var collider: Object = _raycast.get_collider()
	# Try to pick up a pickable item first
	if collider is PickableItem:
		grab_item(collider)
	# Next, try to interact with hand interactible object
	elif collider is Interactible and collider.hand_interactible:
		collider.interact(null)
	# Next, try to interact using the tool on the interactible if the selected item uses raycast
	elif collider is Interactible and _hotbar.selected_item != null and \
			_hotbar.selected_item.use_player_raycast:
		collider.interact(_hotbar.selected_item)
	# Finally, try to use a shape cast on the selected item 
	elif _hotbar.selected_item != null and not _hotbar.selected_item.use_player_raycast:
		collider = _hotbar.selected_item.get_shape_cast_collider()
		if collider is Interactible:
			collider.interact(_hotbar.selected_item)


## Grab an item by adding it to the player's hotbar. Auto-select the item that
## the player just grabbed.
func grab_item(item: PickableItem) -> void:
	var added_index: int = _hotbar.add_item(item)
	if added_index != -1:
		_hotbar.select_index(added_index)


## Drop an item by removing from the player's hotbar, and inserting it back
## into the environment.
func drop_item() -> void:
	# HACK: using get_parent() currently for the environment
	_hotbar.remove_item(_hotbar.selected_index, get_parent())
