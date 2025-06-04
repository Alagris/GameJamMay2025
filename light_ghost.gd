extends CharacterBody2D
@onready var player = get_tree().get_first_node_in_group("player")
var speed:int = 80

@export var animation:AnimatedSprite2D
@export var time_alive_timer:Timer
var time_alive:float = 120
@export var target_timer:Timer
@export var targeting_area:Area2D
@export var damage:float = 10


var current_state:STATE = STATE.IDLE
enum STATE {MOVE,ATTACKING,IDLE}
var dead:bool = false

var desired_movement_location:Vector2
var movement_range:float = 5

var rng = RandomNumberGenerator.new()

func _ready():
	self.add_to_group("enemy")
	target_timer.wait_time = rng.randf_range(5.0,10.0)
	target_timer.start()
	time_alive_timer.wait_time = time_alive
	time_alive_timer.start()


func _physics_process(delta):
	if dead:
		return
	#print(current_state)
	match current_state:
		STATE.MOVE:
			move()
		STATE.ATTACKING:
			pass
		STATE.IDLE:
			animation.play("idle")

func move():
	var direction:Vector2 = (desired_movement_location - self.global_position).normalized()
	match (desired_movement_location - self.global_position).length() < 40:
		true:
			velocity = direction * 0
		false:
			velocity = direction * speed
	move_and_slide()
	match direction.x > 0:
		true:
			$"transform node".scale.x = -1
		false:
			$"transform node".scale.x = 1
	match (absf(velocity.x) + absf(velocity.y)) > 0:
		true:
			animation.play("move")
		false:
			animation.play("idle")

func pick_new_target():
	var potential_targets = targeting_area.get_overlapping_areas()
	if potential_targets.size() == 0:
		pick_random_movement_location()
		current_state = STATE.MOVE
		return
	for i in potential_targets.size():
		if potential_targets[i].ghost_light_target.light_on == true:
			print("found target")
			print(potential_targets)
			desired_movement_location = potential_targets[i].global_position
			current_state = STATE.MOVE
			return
	pick_random_movement_location()
	current_state = STATE.MOVE


func pick_random_movement_location():
	target_timer.wait_time = rng.randf_range(5.0,10.0)
	
	var random_chance = rng.randi_range(0,10)
	if random_chance == 0:
		var random_vector:Vector2 = Vector2(rng.randf_range(-20,20),rng.randf_range(-20,20))
		desired_movement_location = (player.global_position - self.global_position) + random_vector
		return
	var location_x:float = rng.randf_range(-movement_range,movement_range)
	var location_y:float = rng.randf_range(-movement_range,movement_range)
	desired_movement_location = self.global_position + Vector2(location_x,location_y)

func death():
	dead = true
	animation.play("death")
	await get_tree().create_timer(1.0,true).timeout
	self.call_deferred("queue_free")

func i_see_you():
	pass

func _on_hurtbox_area_entered(area):
	print("hurtbox entered")
	if area.is_in_group("ghost attack area"):
		current_state = STATE.ATTACKING
		area.ghost_light_target.turn_off()
		animation.play("attack")
		if area.get_parent() == player:
			player.hurt(damage)

func _on_animated_sprite_2d_animation_finished():
	if animation.animation == "attack":
		animation.play("idle")
