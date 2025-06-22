class_name Trap extends Interactible

signal triggered()


# VARIABLES -------
# Set the area in which a player will die
@export var kill_area : Area3D
## Animation to play when pre triggered
@export var pre_trigger_animation: String
# Set an animation to play when triggered
@export var trigger_animation: String
# Set the name of the item root node required to disarm (can be null for any item to disarm)
@export var disarm_item : String = "Wand"

@export var warning_sound: AudioStreamPlayer3D
@export var attack_sound: AudioStreamPlayer3D

## Force to exert on player when dead from this trap.
@export var death_force := Vector3.ZERO

@onready var anim_player : AnimationPlayer = $AnimationPlayer

var isPreTriggered = false
var isDisarmed = false

# Can be overwritten by child classes if need be
func interact(item: PickableItem) -> void:
	if !disarm_item:
		StatTracker.traps_disarmed += 1
		disarm()
	elif item and item.name == disarm_item:
		StatTracker.traps_disarmed += 1
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
		if warning_sound:
			warning_sound.play()
		await _play_trigger_animation(pre_trigger_animation)
		if warning_sound:
			warning_sound.stop()
		if attack_sound:
			attack_sound.play()
		triggered.emit()
		_attempt_to_kill()
	disarm()

# Trigger the trap if not disarmed
func trigger():
	if isDisarmed:
		return
	else:
		print("Trap triggered")
		if attack_sound:
			attack_sound.play()
		triggered.emit()
		_attempt_to_kill()
		await _play_trigger_animation(trigger_animation)
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
		if attack_sound:
			attack_sound.play()
		await anim_player.animation_finished
		_reverse_trigger_animation(animation_name)

func _reverse_trigger_animation(animation_name: String):
	if anim_player and animation_name:
		anim_player.play_backwards(animation_name)
