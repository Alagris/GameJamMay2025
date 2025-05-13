extends Control

@export var settings_menu:Control
@export var credits_menu:Control
@export var back_button:Button
@export var menu_root:Control
@export var pause_button:Button
@export var mouse_motion_timer:Timer
@export var button_box:VBoxContainer

var game_pausable:bool = true
var pause_state:bool = false
var current_menu:Control = self

func _ready():
	menu_root.hide()
	credits_menu.hide()
	settings_menu.hide()
	pause_button.show()
	back_button.hide()




func _input(event):
	if Input.is_action_just_pressed("escape"):
		match pause_state:
			true:
				escape_requested()
			false:
				pause()
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_motion_timer.stop()
		mouse_motion_timer.start()

func _on_mouse_motion_timer_timeout():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func pause():
	print("pause requested")
	if game_pausable == false:
		print("game can't pause")
		return
	match pause_state:
		true:
			pause_deactivate()
		false:
			pause_activate()

func pause_activate():
	menu_root.show()
	pause_button.hide()
	get_tree().paused = true
	pause_state = true

func pause_deactivate():
	menu_root.hide()
	pause_button.show()
	get_tree().paused = false
	pause_state = false

func escape_requested():
	if current_menu == self:
		pause()
		return
	current_menu.hide()
	button_box.show()
	current_menu = self
	back_button.hide()

func _on_credits_pressed():
	credits_menu.show()
	back_button.show()
	button_box.hide()
	current_menu = credits_menu

func _on_settings_pressed():
	settings_menu.show()
	back_button.show()
	button_box.hide()
	current_menu = settings_menu
