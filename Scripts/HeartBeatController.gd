extends Node

onready var timer = $Timer
onready var fastTimer = $FastTimer
onready var audio = $HeartBeat

signal onHeartBeat
signal onBackToNormal

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

func start_fast_timer():
	fastTimer.start(6)

func _on_Timer_timeout():
	emit_signal("onHeartBeat")
	audio.play()
	timer.start(state + 1)

func _on_FastTimer_timeout():
	state = RYTHM.Normal
	emit_signal("onBackToNormal")

