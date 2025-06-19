class_name Trap extends Interactible

# VARIABLES -------
# Set the area in which a player will die
@export var kill_area : Area3D
# Set an animation to play when triggered
@export var trigger_animation_name : String
# Set the name of the item root node required to disarm (can be null for any item to disarm)
@export var disarm_item : String = "Wand"

@onready var anim_player : AnimationPlayer = $AnimationPlayer

var isPreTriggered = false
var isDisarmed = false

# Can be overwritten by child classes if need be
func interact(item: PickableItem) -> void:
	if !disarm_item: disarm()
	elif item and item.name == disarm_item: disarm()

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

	isPreTriggered = true
	StatTracker.decrement_luck()
	await _play_trigger_animation()
	trigger()

# Trigger the trap if not disarmed
func trigger():
	print("Trap triggered")
	if isDisarmed: return
	elif isPreTriggered: _attempt_to_kill()
	else: print("Player killed") # ADD PLAYER DEATH HERE
	disarm()

func _attempt_to_kill():
	# Early return if no kill area
	if !kill_area: return
	var bodies = kill_area.get_overlapping_bodies()
	print(bodies)
	for body in bodies:
		if body is Player:
			print("Player killed") # ADD PLAYER DEATH HERE

func _play_trigger_animation():
	if anim_player and trigger_animation_name: 
		anim_player.play(trigger_animation_name)
		await anim_player.animation_finished
		_reverse_trigger_animation()

func _reverse_trigger_animation():
	if anim_player and trigger_animation_name: anim_player.play_backwards(trigger_animation_name)
