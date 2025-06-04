extends CharacterBody2D

const SPEED:float = 120

@export var flashlight:Node2D
@export var activity_bar:ProgressBar
@export var canvas_modulate:CanvasModulate
var canvas_modulate_original_color:Color

@export var player_light:PointLight2D
@onready var animated_sprite:AnimatedSprite2D = $animated_spite
const IDLE = 0
const WALK = 1

enum ANIMATE_PATH {ANIMATE_LEFT,ANIMATE_RIGHT,ANIMATE_FORWARD,ANIMATE_BACK}
var dir_int = ANIMATE_PATH.ANIMATE_FORWARD

var going_down:bool = false
var going_up:bool = false
var going_left:bool = false
var going_right:bool = false

const DIR_CHAR = ["L", "R", "F", "B"]
const STATE_ANIM_NAME = ["idle", "walk"]
var walk_state:int = IDLE

var max_ray_length:float = 250
var current_ray_length:float = 250
var ray_length_ratio:float = 1.0

var is_looting:bool = false
var looting_tween:Tween
var transition_time:float = 1.0

func _ready():
	InputManager.new_player_instance()
	InputManager.player_character = self
	canvas_modulate_original_color = canvas_modulate.get_color()

func _process(delta : float) -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity = Vector2(float(going_right)-float(going_left), float(going_down)-float(going_up)).normalized() * SPEED
	if velocity.y>0:
		dir_int = ANIMATE_PATH.ANIMATE_FORWARD
	elif velocity.y<0:
		dir_int = ANIMATE_PATH.ANIMATE_BACK
	elif velocity.x<0:
		dir_int = ANIMATE_PATH.ANIMATE_LEFT
	elif velocity.x>0:
		dir_int = ANIMATE_PATH.ANIMATE_RIGHT
	
	var absolute_velocity:float = absf(velocity.y) + absf(velocity.x)
	
	match absolute_velocity > 0:
		true:
			if is_looting == true:
				is_looting = false
				activity_bar.hide()
				looting_tween.kill()
			walk_state = WALK
			if $"audio/footstep timer".is_stopped():
				$"audio/footstep timer".start()
				$"audio/footstep sounds".play()
		false:
			walk_state = IDLE
	
	animated_sprite.play(STATE_ANIM_NAME[walk_state]+DIR_CHAR[dir_int])
	move_and_slide()

func scale_modulate(new_color:Color):
	var tween = create_tween()
	tween.tween_property(canvas_modulate,"color",new_color,transition_time)

func scale_light(new_scale:Vector2):
	var tween = create_tween()
	tween.tween_property(player_light,"scale",new_scale,transition_time)
	tween.parallel().interpolate_value(ray_length_ratio,player_light.scale.x,1.0,transition_time,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)

func teleport(location:Vector2):
	print("teleport requested")
	InputManager.can_control_player = false
	
	scale_modulate(Color(0,0,0,1))
	scale_light(Vector2(.2,.2))
	await get_tree().create_timer(transition_time,true).timeout
	
	self.global_position = location
	
	scale_modulate(canvas_modulate_original_color)
	scale_light(Vector2(1.0,1.0))
	await get_tree().create_timer(transition_time,true).timeout
	
	InputManager.can_control_player = true
	print("teleport complete")


func _on_footstep_timer_timeout():
	match walk_state:
		IDLE:
			print("idling no sounds playing")
			$"audio/footstep timer".stop()
		WALK:
			$"audio/footstep sounds".play()

func loot(lootable_object:Node2D):
	if flashlight.is_recharging:
		return
	var loot_time:float = 2.0
	var tween = create_tween()
	looting_tween = tween
	is_looting = true
	
	tween.tween_property(activity_bar,"value",100,loot_time)
	activity_bar.show()
	await get_tree().create_timer(loot_time,true).timeout
	if is_looting:
		activity_bar.hide()
		is_looting = false
		lootable_object.looted()

func replace_battery():
	InputManager.can_control_player = false
	await get_tree().create_timer(1.0,true).timeout
	InputManager.can_control_player = true
