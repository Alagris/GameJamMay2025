extends Node2D

@export var pointlight:PointLight2D
@export var battery_timer:Timer
var battery_charge:int = 100
var flashlight_on:bool = false



func _physics_process(delta):
	look_at(get_global_mouse_position())



func turn_on():
	pass

func turn_off():
	pass

func update_brightness():
	var wait_time:float = 0.9
	var tween = create_tween()
	var battery_ratio:float = float(battery_charge)/100
	var scale_y:float = (battery_ratio * .6) + .4
	var scale_brightness:float = (battery_ratio)
	tween.tween_property(pointlight,"scale",Vector2(1.0,scale_y),wait_time)
	var tween_2 = create_tween()
	tween_2.tween_property(pointlight,"energy",scale_brightness,wait_time)

func _on_battery_timer_timeout():
	print("battery timeout")
	battery_charge = clamp(battery_charge - 1,0,100)
	if battery_charge == 0:
		turn_off()
		return
	update_brightness()
	
	
