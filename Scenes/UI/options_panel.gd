class_name OptionsPanel extends Panel

@export var is_main_menu : bool = false

@onready var back_button : Button = %BackButton

func _ready() -> void:
	if is_main_menu:
		back_button.text = "Back"
	else:
		back_button.text = "Back to Main Menu"
	back_button.pressed.connect(_handle_back_button_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		visible = !visible

func _handle_back_button_pressed() -> void:
	visible = false
	if is_main_menu:
		hide()
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
