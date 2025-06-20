class_name InteractionTrap extends Trap

# Can be overwritted by child classes if need be
func interact(item: PickableItem) -> void:
	# If there is no disarm item set
	if !disarm_item: disarm()
	# If there is a disarm item set and there is no item or the item is not the disarm item
	elif item and item.name != disarm_item or item == null: determine_trigger()
	# If there is a disarm item set and the item is the disarm item
	else: disarm()
