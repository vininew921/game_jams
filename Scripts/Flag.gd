extends Area2D

export(String) var nextLevel

func _on_Flag_body_entered(body: Node):
	if body.name == "Player":
		get_tree().change_scene(GlobalController.next_level())
