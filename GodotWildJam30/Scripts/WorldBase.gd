extends Node2D

onready var player = $Player
onready var audioSource = $AudioSource

func _ready():
	player.connect("on_death", self, "_on_Player_on_death")

func _physics_process(delta):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

func _on_Player_on_death():
	audioSource.play()
