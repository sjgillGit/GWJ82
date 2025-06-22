class_name Trap extends Interactible

# VARIABLES -------
# Set the area in which a player will die
@export var kill_area : Area3D
## Animation to play when pre triggered
@export var pre_trigger_animation: String
# Set an animation to play when triggered
@export var trigger_animation: String
# Set the name of the item root node required to disarm (can be null for any item to disarm)
@export var disarm_item : String = "Wand"

## Force to exert on player when dead from this trap.
@export var death_force := Vector3.ZERO

@onready var anim_player : AnimationPlayer = $AnimationPlayer

var isPreTriggered = false
var isDisarmed = false

# Can be overwritten by child classes if need be
func interact(item: PickableItem) -> void:
	if !disarm_item:
		disarm()
	elif item and item.name == disarm_item:
		disarm()

# Disarm trap
func disarm():
	# Early return if already disarmed
	if isDisarmed:
		return
	isDisarmed = true
	print("Trap disarmed")

func determine_trigger():
	if StatTracker.luck <= 0:
		trigger()
	else:
		pre_trigger()
	
# Send a warning before trigger take place
func pre_trigger():
	# Early return if already disarmed
	if isDisarmed:
		return
	else:
		print("Trap pre-triggered")
		isPreTriggered = true
		StatTracker.decrement_luck()
		await _play_trigger_animation(pre_trigger_animation)
		_attempt_to_kill()
	disarm()

# Trigger the trap if not disarmed
func trigger():
	if isDisarmed:
		return
	else:
		print("Trap triggered")
		await _play_trigger_animation(trigger_animation)
		_attempt_to_kill()
	disarm()

func _attempt_to_kill():
	# Early return if no kill area
	if !kill_area:
		push_warning("No kill area for this trap")
		return
	print("Attempting to kill")
	var bodies = kill_area.get_overlapping_bodies()
	print(bodies)
	for body in bodies:
		if body is Player:
			print("Player killed") # ADD PLAYER DEATH HERE
			body.die(death_force)

func _play_trigger_animation(animation_name: String):
	if anim_player and animation_name: 
		anim_player.play(animation_name)
		await anim_player.animation_finished
		_reverse_trigger_animation(animation_name)

func _reverse_trigger_animation(animation_name: String):
	if anim_player and animation_name:
		anim_player.play_backwards(animation_name)
