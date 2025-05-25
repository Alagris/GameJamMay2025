extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var cooldown_timer:Timer
@export var nav:NavigationAgent2D

@export var moving_sound:AudioStreamPlayer2D
@export var stopping_sound:AudioStreamPlayer2D


const MAX_SPEED:float = 200
var current_speed:float = 0.0
var is_seen:bool = false
var can_move:bool = true
var rng = RandomNumberGenerator.new()

func _ready():
	self.add_to_group("enemy angel")


func _physics_process(delta):
	match can_move:
		true:
			current_speed = lerpf(current_speed,MAX_SPEED,0.01)
		false:
			current_speed = lerpf(current_speed,0.0,0.15)
	var direction = (nav.get_next_path_position() - self.global_position).normalized()
	velocity = direction * current_speed
	move_and_slide()

func i_see_you():
	can_move = false
	cooldown_timer.start()
	if moving_sound.is_playing():
		stopping_sound.play()
		moving_sound.stop()

func _on_cooldown_timer_timeout():
	print("can move now")
	can_move = true
	moving_sound.play(rng.randf_range(0.0,3.0))

func _on_moving_sound_finished():
	moving_sound.play()

func _on_nav_update_timer_timeout():
	nav.target_position = player.global_position
