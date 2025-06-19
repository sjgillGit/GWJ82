class_name SettingToggle extends Control

@export var setting_name: String
@export var setting_description: String
@export var setting_default: bool = true
@export var sub_label: String = "(Disable to improve performance)"

@onready var setting_label: Label = %SettingLabel
@onready var setting_toggle: CheckBox = %SettingCheckBox
@onready var sub_label_node: Label = %SubLabel

func _ready() -> void:
	setting_label.text = setting_description
	setting_toggle.button_pressed = VideoSettings[setting_name]
	sub_label_node.text = sub_label

	setting_toggle.pressed.connect(_on_toggle_pressed)

func _on_toggle_pressed() -> void:
	VideoSettings[setting_name] = setting_toggle.button_pressed
	VideoSettings.apply_visual_settings()
