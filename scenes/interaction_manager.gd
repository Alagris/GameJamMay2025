extends Node2D

var power_on:bool = true #used for electricity based lights

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

var active_areas = []
var nearest_area:Item = null
var can_interact = true
func register_area(a: Item):
	active_areas.push_back(a)
	
	
func unregister_area(a: Item):
	var i = active_areas.find(a)
	if i > -1:
		active_areas.remove_at(i)

func _ready():
	$AnimationPlayer.play("Animate Text")

func _process(delta: float) -> void:
	if can_interact && active_areas.size()>0:
		var player_pos:Vector2 = player.global_position
		var nearest_dist = active_areas[0].global_position.distance_to(player_pos)
		nearest_area = active_areas[0]
		for i in range(1, active_areas.size()):
			var d = active_areas[i].global_position.distance_to(player_pos)
			if d < nearest_dist:
				nearest_dist = d
				nearest_area = active_areas[i];
		label.text = '[E] '+nearest_area.action_name
		label.global_position = nearest_area.global_position
		label.global_position.y -= 36
		label.global_position.x -= label.size.x/2
		label.show()
	else:
		nearest_area = null
		label.hide()
		
func _input(event: InputEvent) -> void:
	if can_interact && nearest_area != null && event.is_action_pressed("interact"):
		can_interact = false
		label.set_visible(nearest_area.reusable_interaction)
		await nearest_area.interact.call()
		print("interaction manager test pass")
		can_interact = true
			
