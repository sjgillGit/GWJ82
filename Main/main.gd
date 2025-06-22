extends Node3D


func _ready() -> void:
	StatTracker.all_cleaned.connect(win)

func win():
	%Title.text = "Level Complete!"
	_on_player_died()

func _on_player_died() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$DeadMenu.visible = true
	%TrapsDisarmed.text = str(StatTracker.traps_disarmed)
	%ItemsCleaned.text = str(StatTracker.cleaned_items) + "/" + str(StatTracker.total_items)
	%FinalGrade.text = StatTracker.evaluate_score()


func _on_back_button_pressed() -> void:
	print("PRESSED!")
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
