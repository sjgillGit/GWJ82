class_name Hotbar extends Node3D
## Hotbar containing [Item] nodes.
##
## Items can be stored in a hotbar and taken out of it.
## When stored, the items are actually reparented into the hotbar, so they can
## be positioned using local position easily.


## Signals when an item is added to the hotbar.
signal item_added(slot_index: int, item: Item)
## Signals when an item is removed from the hotbar.
signal item_removed(slot_index: int, item: Item)
## Signals when a slot is selected in the hotbar.
signal slot_selected(slot_index: int)


## The number of item slots (capacity) of the hotbar.
@export_range(1, 10) var slots: int = 3

## Getter to access the currently selected item in the hotbar, returns null if
## there is no item in the selected slot.
@onready var selected_item: Item:
	get:
		assert(_items.size() == slots)
		return _items[selected_index]
## Selected slot index in the hotbar.
@onready var selected_index: int = 0
# Stores references to items in the hotbar.
@onready var _items: Array[Item] = []



func _ready() -> void:
	# Initialize items to be the correct length
	for _slot in range(slots):
		_items.append(null)


## Increments the selected index by 1, selecting the next item in the hotbar.
func increment_selected_index() -> void:
	var new_index = selected_index + 1
	if new_index >= _items.size():
		new_index = 0
	select_index(new_index)


## Decrements the selected index by 1, selecting the previous item in the hotbar.
func decrement_selected_index() -> void:
	var new_index = selected_index - 1
	if new_index < 0:
		new_index = _items.size() - 1
	select_index(new_index)


## Selects an item in the hotbar.
func select_index(index: int) -> void:
	# Hide the old item
	var old_item: Item = _items[selected_index]
	if old_item:
		old_item.visible = false
	
	selected_index = clamp(index, 0, _items.size() - 1)
	
	# Show the new item
	var new_item: Item = _items[selected_index]
	if new_item:
		new_item.visible = true
	
	# Do stuff that happens when an item is selected
	slot_selected.emit(selected_index)


## Adds an item to the hotbar, reparenting it to the hotbar if added successfully.
## Returns the index of the added item, or null if the hotbar is full and the
## item cannot be added.
func add_item(item: Item) -> int:
	var add_index = _find_first_empty_slot()
	
	# Add the item if there is an open slot
	if add_index != -1:
		_items[add_index] = item
		item.reparent(self)
		item.setup_for_hotbar()
		item_added.emit(add_index, item)
	
	return add_index


## Removes an item from slot [param index] and reparents it to [param environment].
## Returns the item that was removed, or null if there was no item in that slot.
## If there is no item, nothing happens. 
func remove_item(index: int, environment: Node3D) -> Item:
	var item: Item = _items[index]
	
	if item != null:
		_items[index] = null
		item.reparent(environment)
		item.setup_for_world()
		item_removed.emit(index, item)
	
	return item


# Returns the first empty slot (null item) at or after the selected slot.
func _find_first_empty_slot() -> int:
	for offset: int in range(_items.size()):
		var slot_index: int = (offset + selected_index) % _items.size()
		if _items[slot_index] == null:
			return slot_index
	return -1
