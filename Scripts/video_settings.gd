extends Node

var use_dither = true
var use_quantize = true

var shader_overlay : ColorRect
var shader_mat : ShaderMaterial

func set_shader_overlay(node: ColorRect):
	# Kinda silly, but it'll do
	shader_overlay = node
	shader_mat = node.material as ShaderMaterial

func apply_visual_settings():
	if shader_mat == null:
		return
	if use_quantize or use_dither:
		shader_overlay.visible = true
		shader_mat.set_shader_parameter("use_quantize", use_quantize)
		shader_mat.set_shader_parameter("use_dithering", use_dither)
	else:
		shader_overlay.visible = false
