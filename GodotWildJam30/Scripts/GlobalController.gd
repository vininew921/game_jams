extends Node

var currentLevel = 0

onready var audio = $Theme

signal damage_player

func next_level():
	currentLevel += 1
	var nextLevel = "res://Scenes/Level_" + str(currentLevel) + ".tscn"
	return nextLevel
	pass

func damage_player():
	emit_signal("damage_player")

func start_theme():
	audio.play()