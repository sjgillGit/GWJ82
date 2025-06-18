class_name InteractLabel
extends Label

@export var player: Player

func _ready():
	visible = false
	player.raycast_hit_changed.connect(display_label)

func display_label(interactible):
	var key = _get_interact_key()
	if interactible is Interactible:
		text = key + " to clean"
		visible = true
	elif interactible is Trap:
		text = key + " to disarm"
		visible = true
	elif interactible is PickableItem:
		text = key + " to pick up"
		visible = true
	else:
		visible = false


func _get_interact_key():
	if (InputMap.has_action("interact")):
		var key = InputMap.action_get_events("interact")[0].as_text()
		if key == "Left Mouse Button":
			return "LMB"
		return key
	else:
		print("No interact action found")
		return "E"
