class_name Cleanable extends Interactible

var is_cleaned : bool = false

@export var clean_scene: PackedScene

func _ready():
	if clean_scene == null:
		var this_scene_path = get_scene_file_path()
		var clean_scene_path = this_scene_path.replace("dirty_", "clean_")
		
		if ResourceLoader.exists(clean_scene_path):
			clean_scene = load(clean_scene_path)
		else:
			push_warning("Clean scene not found for: " + clean_scene_path)


func interact(item: PickableItem):
	if is_cleaned:
		return  # Prevent multiple replacements

	var parent = get_parent()
	var transform = global_transform

	var clean_instance = clean_scene.instantiate()
	clean_instance.global_transform = transform

	parent.add_child(clean_instance)
	queue_free()  # Remove the current (unclean) scene

	is_cleaned = true
