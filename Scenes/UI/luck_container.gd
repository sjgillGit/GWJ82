class_name LuckContainer
extends HBoxContainer

@export var luck_texture: Texture2D

var luck : int = 3

func _ready():
    init_luck()

func init_luck():
    for i in range(luck):
        var luck_icon = TextureRect.new()
        luck_icon.texture = luck_texture
        luck_icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
        add_child(luck_icon)