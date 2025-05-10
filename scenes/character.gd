extends CharacterBody2D

const SPEED:float = 100

enum State {  
	IDLE,      
	WALKING,  
}  

@onready var animated_sprite:AnimatedSprite2D = $animated_spite
const L:int=0
const R:int=1
const F:int=2
const B:int=3


var state: State = State.IDLE

const L_VEC = Vector2(-1, 0)
const R_VEC = Vector2(1, 0)
const F_VEC = Vector2(0, 1)
const B_VEC = Vector2(0, -1)


func _process(delta : float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var f:bool = Input.is_action_pressed("down")
	var l:bool = Input.is_action_pressed("left")
	var r:bool = Input.is_action_pressed("right")
	var b:bool = Input.is_action_pressed("up")
	var dir_vec = float(f) * F_VEC + float(l) * L_VEC + float(r) * R_VEC + float(b) * B_VEC
	velocity = dir_vec.normalized() * SPEED
	if dir_vec==Vector2(0,0):
		
	else:
		
	animated_sprite.play()
	move_and_slide()
	
	
	
