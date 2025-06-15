class_name Player extends CharacterBody3D
## Main player script.
##
## Handles movement of the player. Has a [Hotbar] which can contain [Item] nodes
## that the player may use.


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

# Boolean controlling which movement speed to use.
var _running: bool = false
# Current walk velocity (only x and z)
var _walk_velocity := Vector3.ZERO
# Current vertical velocity due to gravity/jumping (only y)
var _vertical_velocity := Vector3.ZERO

@onready var _camera: Camera3D = $Camera3D
@onready var _raycast: RayCast3D = $Camera3D/RayCast3D
@onready var _hotbar: Hotbar = $Hotbar


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# Update horizontal and vertical velocity and apply movement
	self.velocity = _get_walk_velocity(delta) + _get_vertical_velocity(delta)
	move_and_slide()


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


func _unhandled_input(event: InputEvent) -> void:
	# Pick up an item that the player is looking at when grab is pressed.
	if event.is_action_pressed(&"grab") and _raycast.is_colliding():
		var target_object = _raycast.get_collider()
		if target_object is Item:
			grab_item(target_object)
	
	# Drop an item that the player is currently holding when drop is pressed.
	if event.is_action_pressed(&"drop"):
		drop_item()
	
	if event.is_action_pressed(&"use"):
		pass # Use the item the player is currently holding
		# May need to use location info and raycast hit object to "use" the item
	
	if event.is_action_pressed(&"select_next_hotbar_slot"):
		_hotbar.increment_selected_index()
	
	if event.is_action_pressed(&"select_previous_hotbar_slot"):
		_hotbar.decrement_selected_index()
	
	# Toggle running when pressing/releasing run
	if event.is_action_pressed(&"run"):
		_running = true
	if event.is_action_released(&"run"):
		_running = false
	
	# Handle rotation of camera due to moues movement
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_camera.rotation.y -= event.screen_relative.x * 0.002
		_hotbar.rotation.y = _camera.rotation.y
		_camera.rotation.x -= event.screen_relative.y * 0.002
		_camera.rotation.x = clampf(_camera.rotation.x, -1.5, 1.5)
	
	# TODO: this should be handled in a world level script
	if event.is_action_pressed(&"pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


## Grab an item by adding it to the player's hotbar. Auto-select the item that
## the player just grabbed.
func grab_item(item: Item) -> void:
	var added_index: int = _hotbar.add_item(item)
	if added_index != -1:
		_hotbar.select_index(added_index)


## Drop an item by removing from the player's hotbar, and inserting it back
## into the environment.
func drop_item() -> void:
	# HACK: using get_parent() currently for the environment
	_hotbar.remove_item(_hotbar.selected_index, get_parent())
