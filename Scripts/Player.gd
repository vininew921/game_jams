extends KinematicBody2D

var velocity = Vector2.ZERO
var direction = Vector2.RIGHT

const _HeartBeatController = preload("res://Scenes/HeartBeatController.tscn")
var heartBeat

onready var playerFollower = $PlayerFollower
onready var animation = $AnimationPlayer
onready var sprite = $Sprite

export var MAX_SPEED = 50
export var GRAVITY = 10
export var JUMP_HEIGHT = 100

###Enums
enum STATE{
	Idle,
	Run,
	Jump
}

enum RYTHM{
	Fast,
	Normal,
	Slow
}

var state = STATE.Idle

func _ready():
	heartBeat = _HeartBeatController.instance()
	add_child(heartBeat)
	heartBeat.connect("onHeartBeat", self, "switch_worlds")

func _physics_process(_delta):
	direction = get_direction()
	velocity = get_velocity()
	
	velocity = move_and_slide(velocity, Vector2.UP)

	
	if velocity.x != 0:
		state = STATE.Run
	else:
		state = STATE.Idle

	set_animation()

	if Input.is_action_just_pressed("switch_worlds"):
		heartBeat.state = heartBeat.state - 1
	if Input.is_action_just_pressed("reload"):
		reload_game()

func get_direction():
	var is_jumping = is_on_floor() && Input.is_action_just_pressed("jump")
	var dir = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), is_jumping).normalized()
	return dir

func get_velocity():
	var newVelocity = velocity
	newVelocity.x = direction.x * MAX_SPEED
	newVelocity.y += GRAVITY
	if direction.y > 0:
		newVelocity.y = JUMP_HEIGHT * -1
	return newVelocity

func set_animation():
	if state == STATE.Run:
		if direction.x == Vector2.LEFT.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		animation.play("Running")
	else:
		animation.play("Idle")
	pass

func switch_worlds():
	var oldPosition = self.position
	self.position = playerFollower.global_position
	playerFollower.global_position = oldPosition
	pass

func reload_game():
	get_tree().reload_current_scene()

