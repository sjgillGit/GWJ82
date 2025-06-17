class_name Interactible extends Node3D

# VARIABLES -------
@export var isCleaned = false

# FUNCTIONS -------
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

# For testinge
func _input(event):
	if(event.is_action_pressed("space")):
		interact()

# Cleaning subject
func interact():
	if(not isCleaned):
		StatTracker.add_score(10)
		isCleaned = true
		print("Subject cleaned")
