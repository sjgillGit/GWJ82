extends ColorRect

func _ready():
	print("material type: ",material)
	await get_tree().process_frame
	visible = false
	VideoSettings.set_shader_overlay(self)
	VideoSettings.apply_visual_settings()
