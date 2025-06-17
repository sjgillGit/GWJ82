class_name PickableItem extends RigidBody3D
## Interactable item class.
##
## Objects of this type are items in the game that may be found in the world.
## The player may pick up items and store them in a small hotbar inventory.
## Items may be used while the player is holding them, and have an effect on
## the environment.


## The position to put this [PickableItem] in when held by the player.
@export var hold_position: Vector3
## The rotation of this [PickableItem] when held by the player, in degrees.
@export var hold_rotation_degrees: Vector3


## Sets up this item when added to the hotbar.
func setup_for_hotbar() -> void:
	self.freeze = true
	self.position = hold_position
	self.rotation_degrees = hold_rotation_degrees


## Sets up this item when removed from the hotbar and put back into the world.
func setup_for_world() -> void:
	self.freeze = false
