extends CharacterBody2D


@export var damage:float = 10.0
@onready var player = get_tree().get_first_node_in_group("player")
@export var cooldown_timer:Timer
@export var nav:NavigationAgent2D

@export var moving_sound:AudioStreamPlayer2D
@export var stopping_sound:AudioStreamPlayer2D
@export var animation:AnimatedSprite2D
@export var time_alive_timer:Timer


const MAX_SPEED:float = 200
var current_speed:float = 0.0
var is_seen:bool = false
var can_move:bool = true
var rng = RandomNumberGenerator.new()

@export var time_alive:int



func _ready():
	self.add_to_group("enemy")
	time_alive_timer.wait_time = time_alive
	time_alive_timer.start()


func _physics_process(delta):
	match can_move:
		true:
			animation.play("run")
			current_speed = lerpf(current_speed,MAX_SPEED,0.01)
		false:
			animation.pause()
			current_speed = lerpf(current_speed,0.0,0.15)
	var direction = (nav.get_next_path_position() - self.global_position).normalized()
	velocity = direction * current_speed
	if (absf(velocity.x) + absf(velocity.y)) > 1:
		match direction.x > 0:
			true:
				$"transform node".scale.x = 1
			false:
				$"transform node".scale.x = -1
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


func _on_hurtbox_body_entered(body):
	if body == player:
		player.hurt(damage)
		explode()

func explode():
	print("explode")
	var tween_time:float = 1.0
	cooldown_timer.stop()
	can_move = false
	animation.pause()
	var tween = create_tween()
	tween.tween_property(animation,"scale",Vector2(7,7),tween_time)
	tween.parallel().tween_property(animation,"self_modulate",Color(0,0,0,0),tween_time)
	await get_tree().create_timer(tween_time,true).timeout
	self.call_deferred("queue_free")


func _on_time_alive_timeout():
	explode()
