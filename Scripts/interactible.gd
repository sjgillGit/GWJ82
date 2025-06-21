class_name Interactible extends RigidBody3D

# Add all meshes you would like to be highlighted here
@export var highlight_meshes: Array[MeshInstance3D]


var outline_resource = preload("res://Scripts/Shaders/target_outline.tres")
# VARIABLES -------
## If true, this object can be interacted with by hand (without a tool).
## Hand interactions are currently prioritized over tool/item interactions.
# FUNCTIONS -------

## This variable is ONLY used by the player. Should never change. Feel free to delete, but the player's code will need to be adjusted to handle the change
var hand_interactible = true

func _ready() -> void:
	if (highlight_meshes == null):
		var mesh = get_node_or_null("MeshInstance3D")
		if (mesh != null):
			print("No mesh set in interactible, defaulting to MeshInstance3D")
			highlight_meshes = [mesh]
		else:
			print("No mesh set in interactible")


# To be used differently by all classes extending Interactible
func interact(_item: PickableItem):
	pass

func highlight(_item: PickableItem = null) -> void:
	if (highlight_meshes != null):
		for mesh in highlight_meshes:
			mesh.material_overlay = outline_resource

func unhighlight() -> void:
	if (highlight_meshes != null):
		for mesh in highlight_meshes:
			mesh.material_overlay = null
