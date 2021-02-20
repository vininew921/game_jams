#HeartBeat audio - all credits to InspectorJ at FreeSound -> https://freesound.org/people/InspectorJ/sounds/485076/
extends Node

onready var timer = $Timer
onready var audio = $HeartBeat

signal onHeartBeat

enum RYTHM{
	Fast,
	Normal,
	Slow
}

export var state = RYTHM.Normal setget set_rythm

func _ready():
	timer.start(state + 1)

func set_rythm(value):
	state = value

func _on_Timer_timeout():
	emit_signal("onHeartBeat")
	audio.play()
	timer.start(state + 1)

