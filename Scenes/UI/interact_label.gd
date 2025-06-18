class_name InteractLabel
extends Label

@export var player: Player

func _ready():
	visible = false
	player.raycast_hit_changed.connect(display_label)

func display_label(interactible):
	var key = _get_interact_key()
	# if interactible is Interactible:
	# 	text = key + " to clean"
	# 	visible = true
	# elif interactible is trap:
	# 	text = key + " to disarm"
	# 	visible = true
	# elif interactible is Item:
	# 	text = key + " to pick up"
	# 	visible = true
	# else:
	# 	visible = false


func _get_interact_key():
	# There's probably a better way to grab this key
	return InputMap.action_get_events("grab")[0].as_text()[0]
