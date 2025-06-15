extends Node3D

# VARIABLES -------
@export var is_cleaned = false

var score = 0

# FUNCTIONS -------
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

# For testinge
func _input(event):
	if(event.is_action_pressed("space")):
		interact()

func interact():
	if(not is_cleaned):
		score += 1
		is_cleaned = true
		print("Subject cleaned")
