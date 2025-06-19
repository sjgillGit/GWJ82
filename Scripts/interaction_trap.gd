class_name InteractionTrap extends Trap

# Can be overwritted by child classes if need be
func interact(item: PickableItem) -> void:
	# If disarm item is set, and item used is not the correct one, trigger
	if disarm_item and item and item.name != disarm_item: determine_trigger()
	disarm()
