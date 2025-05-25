extends Node2D
@export var player:CharacterBody2D
@export var flashlight:Node2D
const raycast_max_length:float = 480.0
var raycast_length:float = 480.0

var raycast_node_array:Array = []

func _ready():
	raycast_node_array = get_children().duplicate(true)
	for i in raycast_node_array.size():
		raycast_node_array[i].add_exception(player)

func _physics_process(delta):
	
	update_ray_length()
	if flashlight.flashlight_on == false:
		return
	for i in raycast_node_array.size():
		if not raycast_node_array[i].is_colliding():
			continue
		var collider = raycast_node_array[i].get_collider()
		if not collider.is_in_group("enemy angel"):
			continue
		collider.i_see_you()


func update_ray_length():
	var new_length:float
	match flashlight.flashlight_on:
		true:
			new_length = raycast_max_length * flashlight.flashlight_scale_y
		false:
			new_length = player.player_light.scale.x * (100.0 * player.ray_length_ratio)
	new_length = maxf(new_length,60.0)
	for i in raycast_node_array.size():
		raycast_node_array[i].target_position.y = new_length
