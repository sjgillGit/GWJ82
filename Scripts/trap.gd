extends Area3D

# VARIABLES -------
@export var is_triggered = false

var rng = RandomNumberGenerator.new()
var is_disarmed = false
var disarm_failure_probablity = 0.143 # 1/7


# FUNCTIONS -------
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

# For testinge
func _input(event):
	if(event.is_action_pressed("R")):
		disarm()
	if(event.is_action_pressed("E")):
		trigger()

# Disarm the trap with a probability of 1/7 to trigger it
func disarm():
	if(not is_disarmed):
		var random_num = rng.randf() # Returns a pseudo-random float between 0.0 and 1.0 (inclusive)
		
		if(random_num < disarm_failure_probablity):
			print("Oups, looks like disarming operation failed...")
			trigger()
		else:
			is_disarmed = true
			print("Trap disarmed")

# Send a warning before trigger take place
func preTrigger():
	print("Trap warning !")

# Trigger the trap if not disarmed
func trigger():
	if(not is_disarmed):
		preTrigger()
		is_triggered = true
		print("Trap triggered")
