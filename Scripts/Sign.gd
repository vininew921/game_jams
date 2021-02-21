extends Node2D

onready var textDisplay = $Text


export var TEXT = "test text"

func _ready():
	textDisplay.bbcode_text = "[center]" + TEXT + "[/center]"

func show_text(option):
	textDisplay.visible = option
	pass

func _on_PlayerRange_body_entered(body):
	if body.name == "Player":
		show_text(true)
		
func _on_PlayerRange_body_exited(body):
	if body.name == "Player":
		show_text(false)