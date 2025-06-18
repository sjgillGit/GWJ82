class_name VolumeSlider extends Control

@export var bus_name := "Master"
@export var test_sound : String

@onready var volume_slider : HSlider = %VolumeSlider
@onready var volume_label : Label = %VolumeLabel
@onready var bus_name_label : Label = %BusName
@onready var test_player : AudioStreamPlayer = %TestPlayer

var bus_index : int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

	volume_slider.connect("value_changed", _on_volume_slider_value_changed)
	volume_slider.value = AudioServer.get_bus_volume_db(bus_index)

	volume_label.text = str(int(volume_slider.value * 100)) + "%"

	bus_name_label.text = bus_name

	if test_sound:
		test_player.stream = load(test_sound)
		test_player.bus = bus_name

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	volume_label.text = str(int(value * 100)) + "%"
	if test_sound and !test_player.playing:
		test_player.play()