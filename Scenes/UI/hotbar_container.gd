class_name HotbarContainer
extends HBoxContainer

@export var hotbar: Hotbar

func _ready():
	hotbar.slot_selected.connect(_highlight_slot)
	for i in range(hotbar.slots):
		var hotbar_slot = PanelContainer.new()
		hotbar_slot.custom_minimum_size = Vector2(64, 64)
		add_child(hotbar_slot)
	_highlight_slot(0)

func _highlight_slot(index: int):
	for i in range(hotbar.slots):
		var hotbar_slot = get_child(i)
		if i == index:
			hotbar_slot.modulate = Color(1, 1, 1, 1)
		else:
			hotbar_slot.modulate = Color(1, 1, 1, 0.5)
			
			


#COMMENT ON THIS PLEASEEEEE - Jecht
