extends Node2D
@export var activity_bar:ProgressBar
@export var pointlight:PointLight2D
@export var battery_timer:Timer
@export var flashlight_click_sound:AudioStreamPlayer2D
@export var replace_battery_prompt:Label
@export var battery_recharge_particle:CPUParticles2D
var battery_charge:int = 100
var battery_ratio:float = 1.0

var flashlight_scale_y:float = 1.0

var flashlight_on:bool = false


func _ready():
	InputManager.flashlight = self

func _physics_process(delta):
	if InputManager.can_control_player == false:
		return
	look_at(get_global_mouse_position())
	check_flashlight_actions()
	
func check_flashlight_actions():
	if Input.is_action_just_pressed("toggle flashlight"):
		flashlight_toggle()
	if Input.is_action_just_pressed("recharge flashlight"):
		recharge_flashlight()

func update_brightness():
	var wait_time:float = 0.9
	
	battery_ratio = float(battery_charge)/100
	flashlight_scale_y = (battery_ratio * .6) + .4
	var scale_brightness:float = (battery_ratio * .8) + .2
	
	var tween = create_tween()
	tween.tween_property(pointlight,"scale",Vector2(1.0,flashlight_scale_y),wait_time)
	tween.parallel().tween_property(pointlight,"energy",scale_brightness,wait_time)

func recharge_flashlight():
	print(SaveManager.battery_count)
	if not SaveManager.battery_count > 0:
		return
	SaveManager.battery_count -= 1
	InputManager.can_control_player = false
	replace_battery_prompt.hide()
	print("recharging flashlight")
	var flashlight_was_on:bool = flashlight_on
	battery_charge = 0
	flashlight_on = false
	pointlight.hide()
	flashlight_click_sound.play()
	activity_bar.value = 0.0
	activity_bar.show()
	var tween = create_tween()
	tween.tween_property(activity_bar,"value",100.0,1.0)
	await get_tree().create_timer(1,true).timeout
	activity_bar.hide()
	battery_recharge_particle.emitting = true
	battery_charge = 100
	pointlight.scale = Vector2(1.0,1.0)
	pointlight.energy = 1.0
	if flashlight_was_on:
		flashlight_on = true
		flashlight_click_sound.play()
		pointlight.show()
	InputManager.can_control_player = true


func flashlight_die(battery_death:bool):
	print("flashlight has died")
	if battery_death:
		battery_charge = 0
		replace_battery_prompt.show()
	flashlight_on = false
	battery_timer.set_paused(true)
	#flicker light here
	pointlight.hide()

func flashlight_toggle():
	flashlight_click_sound.play()
	#print("toggle flashlight requested")
	if battery_charge > 0:
		#print("toggle flashlight success")
		
		flashlight_on = !flashlight_on
		print("flashlight state " + str(flashlight_on))
		pointlight.set_visible(flashlight_on)
		battery_timer.set_paused(!flashlight_on)

func battery_drain():
	#print("battery timeout")
	if flashlight_on == false:
		return
	if battery_charge == 1:
		flashlight_die(true)
		return
	battery_charge = clamp(battery_charge - 1,0,100)
	update_brightness()
