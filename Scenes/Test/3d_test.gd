extends Node3D


func _on_player_raycast_hit_changed(raycast_hit: Object) -> void:
	$CanvasLayer/Label.text = str(raycast_hit)
