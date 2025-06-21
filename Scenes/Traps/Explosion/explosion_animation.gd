extends Node3D

## Runs the explosion animation (a sound + particle effects).
func explode() -> void:
	$FireParticles.emitting = true
	$AudioStreamPlayer3D.play()
	$ExplosionParticles.restart()
	await $AudioStreamPlayer3D.finished
	$FireParticles.emitting = false
