class_name LuckContainer
extends HBoxContainer

@export var luck_texture: Texture2D

func _ready():
	StatTracker.luck_changed.connect(_refresh_luck)
	_refresh_luck()

func _refresh_luck():
	for i in range(StatTracker.luck):
		var luck_icon = TextureRect.new()
		luck_icon.texture = luck_texture
		luck_icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		add_child(luck_icon)
