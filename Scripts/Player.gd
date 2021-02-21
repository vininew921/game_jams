extends KinematicBody2D

const _HeartBeatController = preload("res://Scenes/HeartBeatController.tscn")

signal on_death

var velocity = Vector2.ZERO
var direction = Vector2.RIGHT
var heartBeat = null
var can_switch = true
var hasSwitched = false

onready var playerFollower = $PlayerFollower
onready var animation = $AnimationPlayer
onready var sprite = $Sprite
onready var jumpSound = $AudioSource

export var MAX_SPEED = 50
export var GRAVITY = 10
export var JUMP_HEIGHT = 100
export var ACCELERATION = 100
export var TARGET_FPS = 60

###Enums
enum STATE{
	Idle,
	Run,
	Jump,
	Dead
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

func _physics_process(delta):
	direction = get_direction()
	velocity = get_velocity(delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

	set_animation()

	if Input.is_action_just_pressed("switch_worlds"):
		can_switch = !can_switch


func get_direction():
	var dir = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0).normalized()
	return dir

func get_velocity(delta):
	var newVelocity = velocity

	if direction.x != 0:
		state = STATE.Run
		newVelocity.x = direction.x * ACCELERATION
		newVelocity.x = clamp(newVelocity.x, -MAX_SPEED, MAX_SPEED)
	else:
		state = STATE.Idle

	newVelocity.y += GRAVITY * delta * TARGET_FPS

	if is_on_floor():
		if direction.x == 0:
			newVelocity.x = 0
			#newVelocity.x = lerp(newVelocity.x, 0, FRICTION * delta)
		if Input.is_action_just_pressed("jump"):
			jumpSound.play()
			newVelocity.y = -JUMP_HEIGHT
	else:
		state = STATE.Jump
		if Input.is_action_just_released("jump") and newVelocity.y < -JUMP_HEIGHT/2:
			newVelocity.y = -JUMP_HEIGHT/2
		if direction.x == 0:
			newVelocity.x = 0

	return newVelocity

func set_animation():
	match state:
		STATE.Run:
			animation.play("Running")

		STATE.Idle:
			animation.play("Idle")

		STATE.Jump:
			animation.play("Jump")
		
	if direction.x != 0:
		sprite.flip_h = direction.x == Vector2.LEFT.x
	pass

func switch_worlds():
	if can_switch:
		hasSwitched = true
		var oldPosition = self.position
		self.position = playerFollower.global_position
		playerFollower.global_position = oldPosition
	
	if is_inside_wall():
		death()
	pass

func death():
	emit_signal("on_death")
	queue_free()

func is_inside_wall():
	return test_move(self.transform, Vector2.UP) && test_move(self.transform, Vector2.DOWN) && test_move(self.transform, Vector2.LEFT) && test_move(self.transform, Vector2.RIGHT)

