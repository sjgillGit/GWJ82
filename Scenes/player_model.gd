extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


## Plays ragdoll animation, applying an impulse to the torso of the player.
func ragdoll_animation(impulse: Vector3) -> void:
	$Armature/Skeleton3D/PhysicalBoneSimulator3D.physical_bones_start_simulation()
	$Armature/Skeleton3D/PhysicalBoneSimulator3D/Torso.apply_central_impulse(impulse)
