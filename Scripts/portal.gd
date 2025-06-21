@tool
class_name Portal extends Interactible

@export var exit_portal : Portal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		print("Please modify collision shape")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact(player):
	player.transform = exit_portal.transform
	
