extends CharacterBody2D

const SPEED:float = 120

@export var canvas_modulate:CanvasModulate
var canvas_modulate_original_color:Color

var transition_time:float = 1.0


@export var player_light:PointLight2D
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

var can_control:bool = true

func _ready():
	canvas_modulate_original_color = canvas_modulate.get_color()

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
		
	match can_control:
		true:
			animated_sprite.play(STATE_ANIM_NAME[state_int]+DIR_CHAR[dir_int])
			move_and_slide()
			if state_int == WALK:
				if $"audio/footstep timer".is_stopped():
					$"audio/footstep timer".start()
					$"audio/footstep sounds".play()
		false:
			state_int = IDLE
			animated_sprite.play(STATE_ANIM_NAME[state_int]+DIR_CHAR[dir_int])
	
	


func scale_modulate(new_color:Color):
	var tween = create_tween()
	tween.tween_property(canvas_modulate,"color",new_color,transition_time)

func scale_light(new_scale:Vector2):
	var tween = create_tween()
	Tween
	tween.tween_property(player_light,"scale",new_scale,transition_time)

func teleport(location:Vector2):
	print("teleport requested")
	can_control = false
	
	scale_modulate(Color(0,0,0,1))
	scale_light(Vector2(.2,.2))
	await get_tree().create_timer(transition_time,true).timeout
	
	self.global_position = location
	
	scale_modulate(canvas_modulate_original_color)
	scale_light(Vector2(1.0,1.0))
	await get_tree().create_timer(transition_time,true).timeout
	
	can_control = true
	print("teleport complete")


func _on_footstep_timer_timeout():
	if state_int == IDLE:
		print("idling no sounds playing")
		$"audio/footstep timer".stop()
		return
	$"audio/footstep sounds".play()

func replace_battery():
	can_control = false
	
	
	await get_tree().create_timer(1.0,true).timeout
	can_control = true
