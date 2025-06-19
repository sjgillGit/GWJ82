class_name Trap extends Interactible

# VARIABLES -------
# Set an animation to play when triggered
@export var trigger_animation_name : String
# Set the name of the item root node required to disarm (can be null for any item to disarm)
@export var disarm_item : String = "Wand"

@onready var anim_player : AnimationPlayer = $AnimationPlayer

var isPreTriggered = false
var isDisarmed = false

# Can be overwritted by child classes if need be
func interact(item: PickableItem) -> void:
	# If disarm item is set, and item used is not the correct one, return
	if disarm_item and item and item.name != disarm_item: return
	disarm()

# Disarm trap
func disarm():
	# Early return if already disarmed
	if isDisarmed: return
	isDisarmed = true
	print("Trap disarmed")

func determine_trigger():
	if StatTracker.luck <= 0: trigger()
	else: pre_trigger()
	
# Send a warning before trigger take place
func pre_trigger():
	# Early return if already disarmed
	if isDisarmed: return
	if !isPreTriggered: isPreTriggered = true
	print("Trap warning !")
	StatTracker.decrement_luck()
	trigger()

# Trigger the trap if not disarmed
func trigger():
	if anim_player and trigger_animation_name: anim_player.play(trigger_animation_name)
	print("Trap triggered")
	disarm()
