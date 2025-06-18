class_name Interactible extends RigidBody3D
@export var current_mesh : MeshInstance3D

var outline_resource = preload("res://Scripts/Shaders/target_outline.tres")

# VARIABLES -------
## If true, this object can be interacted with by hand (without a tool).
## Hand interactions are currently prioritized over tool/item interactions.
@export var hand_interactible: bool = false

@export var isCleaned = false

# FUNCTIONS -------
func _ready() -> void:
	if (current_mesh == null):
		var mesh = get_node_or_null("MeshInstance3D")
		if (mesh != null):
			print("No mesh set in interactible, defaulting to MeshInstance3D")
			current_mesh = mesh
		else:
			print("No mesh set in interactible")

func _process(delta: float) -> void:
	pass

# Cleaning subject
func interact(_item: PickableItem):
	if(not isCleaned):
		StatTracker.add_score(10)
		isCleaned = true
		print("Subject cleaned")

func highlight(_item: PickableItem = null) -> void:
	if (current_mesh != null):
		current_mesh.material_overlay = outline_resource

func unhighlight() -> void:
	if (current_mesh != null):
		current_mesh.material_overlay = null
