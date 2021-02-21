extends Node

var currentLevel = 0

onready var audio = $Theme

func next_level():
	currentLevel += 1
	var nextLevel = "res://Scenes/Level_" + str(currentLevel) + ".tscn"
	return nextLevel
	pass

func start_theme():
	audio.play()