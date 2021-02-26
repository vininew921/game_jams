extends KinematicBody2D

onready var sprite = $AnimatedSprite
onready var playerDetectionZone = $PlayerDetectionZone
onready var timer = $Timer

var start_position
var target_position
var state
var velocity = Vector2.ZERO

export var wander_range = 30

enum{
	Idle,
	Chase,
	Wander
}

func _ready():
	randomize()
	state = pick_random_state([Idle, Wander])
	start_position = global_position
	target_position = global_position
	pass

func _physics_process(delta):
	match state:
		Idle:
			velocity = velocity.move_toward(Vector2.ZERO, 100 * delta)
			pass

		Chase:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			pass

		Wander:
			accelerate_towards_point(target_position, delta)
			if global_position.distance_to(target_position) <= 50 * delta:
				update_wander_state()
			pass
	velocity = move_and_slide(velocity)

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func accelerate_towards_point(pos, delta):
	var direction = global_position.direction_to(pos)
	velocity = velocity.move_toward(direction * 50, 100 * delta)
	sprite.flip_h = velocity.x < 0

func update_target_position():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	target_position = start_position + target_vector

func get_time_left():
	return timer.time_left

func update_wander_state():
	state = pick_random_state([Idle, Wander])
	start_wander_timer(rand_range(1, 3))

func start_wander_timer(duration):
	timer.start(duration)

func _on_PlayerDetectionZone_body_entered(body):
	if body.name == "Player":
		state = Chase

func _on_PlayerDetectionZone_body_exited(body):
	if body.name == "Player":
		update_wander_state()

func _on_PlayerDamageArea_body_entered(body):
	if body.name == "Player":
			GlobalController.damage_player()

func _on_Timer_timeout():
	update_target_position()
	if state != Chase:
		update_wander_state()
	pass