extends Node2D

@export var light_type:LIGHT_TYPE = LIGHT_TYPE.CONSTANT
enum LIGHT_TYPE {CONSTANT,FLUCTUATE,FLICKER}
@export var light_on:bool = true

var light_distance_scale:Vector2



func _ready():
	InteractionManager.powered_objects.append(self)
	light_distance_scale = self.scale
	match light_on:
		true:
			$Area2D.action_name = "Turn Off"
			turn_on()
		false:
			$Area2D.action_name = "Turn On"
			turn_off()
			$"Light Object".scale = Vector2(0,0)
			
	match light_type:
		LIGHT_TYPE.CONSTANT:
			pass
		LIGHT_TYPE.FLUCTUATE:
			pass
		LIGHT_TYPE.FLICKER:
			pass

func interact():
	$"flick sound".play()
	match light_on:
		true:
			turn_off()
			light_on = false
			$Area2D.action_name = "Turn On"
		false:
			light_on = true
			turn_on()
			$Area2D.action_name = "Turn Off"

func power_on():
	if light_on:
		turn_on()

func power_off():
	if light_on:
		turn_off()

func turn_off():
	var tween = create_tween()
	tween.tween_property($"Light Object","scale",Vector2(0,0),1.0)

func turn_on():
	if InteractionManager.power_on == true:
		var tween = create_tween()
		tween.tween_property($"Light Object","scale",Vector2(1,1),1.0)
