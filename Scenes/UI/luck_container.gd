class_name LuckContainer
extends HBoxContainer

# This could be cleaned up nicely with an array, but since someone else will have to set these up, I've made it very explicit
# There will be five sprites from XVO, set them here and watch the magic happen
@export var four_luck: CompressedTexture2D
@export var three_luck: CompressedTexture2D
@export var two_luck: CompressedTexture2D
@export var one_luck: CompressedTexture2D
@export var zero_luck: CompressedTexture2D

@onready var luck_texture = %LuckTexture
func _ready():
	StatTracker.luck_changed.connect(_refresh_luck)
	_refresh_luck()

func _refresh_luck():
	if !four_luck:
		push_warning("LuckContainer: Luck textures not set")
		return
	match StatTracker.luck:
		4:
			luck_texture.texture = four_luck
		3:
			luck_texture.texture = three_luck
		2:
			luck_texture.texture = two_luck
		1:
			luck_texture.texture = one_luck
		0:
			luck_texture.texture = zero_luck
