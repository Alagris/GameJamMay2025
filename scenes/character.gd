extends CharacterBody2D

const SPEED:float = 100

@onready var animated_sprite:AnimatedSprite2D = $animated_spite
const IDLE = 0
const WALK = 1
const L=0
const R=1
const F=2
const B=3
const DIR_CHAR = ["L", "R", "F", "B"]
const STATE_ANIM_NAME = ["idle", "walk"]
var state_int = IDLE
var dir_int = F

func _process(delta : float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var f:bool = Input.is_action_pressed("down")
	var l:bool = Input.is_action_pressed("left")
	var r:bool = Input.is_action_pressed("right")
	var b:bool = Input.is_action_pressed("up")
	var dir_vec = Vector2(float(r)-float(l), float(f)-float(b)) 
	velocity = dir_vec.normalized() * SPEED
	state_int = WALK
	if dir_vec.y>0:
		dir_int = F
	elif dir_vec.y<0:
		dir_int = B
	elif dir_vec.x<0:
		dir_int = L
	elif dir_vec.x>0:
		dir_int = R
	else:
		state_int = IDLE
	animated_sprite.play(STATE_ANIM_NAME[state_int]+DIR_CHAR[dir_int])
	move_and_slide()
	
	
