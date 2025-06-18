@tool
class_name PickableItem extends Interactible
## Interactable item class.
##
## Objects of this type are items in the game that may be found in the world.
## The player may pick up items and store them in a small hotbar inventory.
## Items may be used while the player is holding them, and have an effect on
## the environment.


## Whether to use the player's raycast to get the target of using this item.
## If false, a child [ShapeCast3D] must be defined to use instead.
@export var use_player_raycast: bool = true:
	set(value):
		use_player_raycast = value
		update_configuration_warnings()
## The position to put this [PickableItem] in when held by the player.
@export var hold_position: Vector3
## The rotation of this [PickableItem] when held by the player, in degrees.
@export var hold_rotation_degrees: Vector3

## This item's [ShapeCast3D]. Only valid if [member use_player_raycast] is false.
@onready var _shape_cast: ShapeCast3D = _get_child_shape_cast()


func _ready() -> void:
	if not Engine.is_editor_hint():
		# Default to player raycast if no shape cast is detected
		if not use_player_raycast and _shape_cast == null:
			push_error("No shape cast found, using player raycast instead...")
			use_player_raycast = true


# Returns the first ShapeCast3D child node
func _get_child_shape_cast() -> ShapeCast3D:
	var children := get_children()
	var shape_cast_index: int = children.find_custom(func(node): return node is ShapeCast3D)
	return children[shape_cast_index] if shape_cast_index >= 0 else null


func _get_configuration_warnings() -> PackedStringArray:
	if not use_player_raycast and _get_child_shape_cast() == null:
		return["PickableItems that don't rely on the player raycast require a ShapeCast3D"]
	return []


## Updates the shape cast and returns the first object colliding with the shape
## cast, or null if no objects are colliding. Should only be used when there is
## a shape cast node in the item's tree.
func get_shape_cast_collider() -> Object:
	if _shape_cast:
		return _shape_cast.get_collider(0) if _shape_cast.get_collision_count() > 0 else null
	else:
		push_error("This PickableItem does not have a ShapeCast3D!")
		return null


## Sets up this item when added to the hotbar.
func setup_for_hotbar() -> void:
	self.freeze = true
	self.position = hold_position
	self.rotation_degrees = hold_rotation_degrees


## Sets up this item when removed from the hotbar and put back into the world.
func setup_for_world() -> void:
	self.freeze = false


# Update when the child nodes are modified in any way
func _on_child_order_changed() -> void:
	update_configuration_warnings()
