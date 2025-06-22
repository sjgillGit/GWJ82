extends Node

# VARIABLES -------
var score = 0
var luck = 0 # CHANGE BACK !!!

var traps_disarmed = 0
var total_items = 0
var cleaned_items = 0:
	set(value):
		cleaned_items = value
		if value >= total_items:
			all_cleaned.emit()

signal all_cleaned

signal luck_changed

# FUNCTIONS -------
# Set score to zero
func reset():
	traps_disarmed = 0
	total_items = 0
	cleaned_items = 0
	luck = 4
	
# Return a grade (A,B,C,D,E,F) from score
func evaluate_score(): 
	score = (cleaned_items as float / total_items as float) * 100 + traps_disarmed
	if score > 99:
		return "A+"
	elif score > 89:
		return "A"
	elif score > 79:
		return "B"
	elif score > 69:
		return "C"
	elif score > 59:
		return "D"
	elif score > 49:
		return "E"
	else:
		return "F"
	
func decrement_luck():
	luck -= 1
	luck_changed.emit()
