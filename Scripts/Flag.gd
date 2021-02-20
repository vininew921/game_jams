extends Area2D

export(String) var nextLevel

func _on_Flag_body_entered(body: Node):
	if body.name == "Player":
		print(nextLevel)
		get_tree().change_scene("res://Scenes/" + nextLevel + ".tscn")
