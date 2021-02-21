extends Node2D

func _on_Button_pressed():
		GlobalController.start_theme()
		get_tree().change_scene(GlobalController.next_level())