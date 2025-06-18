extends Area3D

# VARIABLES -------
@export var isTriggered = false
@export var trigger_areas : Array[CollisionShape3D]

var rng = RandomNumberGenerator.new()
var isDisarmed = false
var disarmFailureProbablity = 0.143 # 1/7


# FUNCTIONS -------
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

# Disarm the trap with a probability of 1/7 to trigger it
func disarm():
	if(not isDisarmed):
		var randomNum = rng.randf() # Returns a pseudo-random float between 0.0 and 1.0 (inclusive)
		
		if(randomNum < disarmFailureProbablity):
			print("Oups, looks like disarming operation failed...")
			pre_trigger()
		else:
			isDisarmed = true
			print("Trap disarmed")

# Send a warning before trigger take place
func pre_trigger():
	print("Trap warning !")
	trigger()

# Trigger the trap if not disarmed
func trigger():
	if(not isDisarmed):
		isTriggered = true
		isDisarmed = true # Get disarmed when triggered - No second use
		print("Trap triggered")
