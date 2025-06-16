extends Node

# VARIABLES -------
var score = 0

# FUNCTIONS -------
# Set score to zero
func reset():
	score = 0
# Return a grade (A,B,C,D,E,F) from score
func evaluate_score():
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
# Add/Substract to the score
func add_score(amount):
	score = score + amount
	
