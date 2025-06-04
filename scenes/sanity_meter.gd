extends MarginContainer

@export var player:CharacterBody2D
@export var meter_1:TextureProgressBar
@export var meter_2:TextureProgressBar
@export var meter_3:TextureProgressBar
@export var meter_4:TextureProgressBar

var max_value:float = 100.0
var current_value:float = 100.0
var value_ratio:float = 1.0

var max_progress_value:float = 84.0
var progress_value:float = 84.0

var first_threshold:float = 58.5
var second_threshold:float = 34.0
var meter_1_down:bool = false
var meter_2_down:bool = false

func _ready():
	change_bar(100)

func tween_bar_to_value(value:float,bar:TextureProgressBar,tween_time:float):
	var tween = create_tween()
	tween.tween_property(bar,"value",value,tween_time)
	
	
func tween_alpha(value:Color,bar:TextureProgressBar,tween_time:float):
	var tween = create_tween()
	tween.tween_property(bar,"self_modulate",value,tween_time)

func change_bar(new_value):
	var tween_speed:float = .2
	current_value = clampf(current_value + new_value,0,100)
	value_ratio = current_value / 100
	var progress_value = clampf((value_ratio * max_progress_value),9.79,max_progress_value)
	
	if current_value == 0:
		player.death()
		return
	
	if progress_value > first_threshold:
		if meter_1_down == true:
			meter_1_down = false
			tween_alpha(Color(1,1,1,1),meter_1,1.0)
		tween_bar_to_value(progress_value,meter_1,.2)
	if progress_value > second_threshold:
		if meter_2_down == true:
			meter_2_down = false
			tween_alpha(Color(1,1,1,1),meter_2,1.0)
		tween_bar_to_value(progress_value,meter_2,.2)
		
	if progress_value < first_threshold:
		if meter_1_down == false:
			meter_1_down = true
			tween_bar_to_value(0.0,meter_1,6.0)
			tween_alpha(Color(1,1,1,0),meter_1,.4)
		tween_bar_to_value(progress_value,meter_3,.2)
	if progress_value < second_threshold:
		if meter_2_down == false:
			meter_2_down = true
			tween_bar_to_value(0.0,meter_2,3.0)
			tween_alpha(Color(1,1,1,0),meter_2,.5)
		tween_bar_to_value(progress_value,meter_3,.2)
	
	
