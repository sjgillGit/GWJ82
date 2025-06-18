class_name Interactible extends RigidBody3D

# VARIABLES -------
@export var isCleaned = false

# FUNCTIONS -------
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

# Cleaning subject
func interact(_item: PickableItem):
	if(not isCleaned):
		StatTracker.add_score(10)
		isCleaned = true
		print("Subject cleaned")

func highlight(_item: PickableItem) -> void:
	pass

func unhighlight() -> void:
	pass
