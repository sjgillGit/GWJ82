class_name MenuOptions extends VBoxContainer

@export var game_title: String
@export var play_scene: PackedScene

@onready var game_title_label: Label = %GameTitle
@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %ExitButton
@onready var options_panel: OptionsPanel = %OptionsPanel

func _ready() -> void:
	game_title_label.text = game_title
	play_button.pressed.connect(_handle_play_button_pressed)
	settings_button.pressed.connect(_handle_settings_button_pressed)
	quit_button.pressed.connect(_handle_quit_button_pressed)

func _handle_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(play_scene)

func _handle_settings_button_pressed() -> void:
	if options_panel.visible:
		return options_panel.hide()
	options_panel.show()

func _handle_quit_button_pressed() -> void:
	get_tree().quit()
