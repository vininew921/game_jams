extends Area2D

var start_position

enum STATE{
	Idle,
	Chase,
	Wander
}

func _ready():
	start_position = self.global_position
	pass

func _physics_process(delta):

	pass