extends Control

@export var settings_menu:Control
@export var credits_menu:Control
@export var back_button:Button
@export var menu_root:Control
@export var pause_button:Button
@export var mouse_motion_timer:Timer
@export var button_box:VBoxContainer

@export var battery_icon:PackedScene
@export var battery_container:HBoxContainer
var battery_array:Array = []

@export var fuse_1:TextureRect
@export var fuse_2:TextureRect
@export var fuse_3:TextureRect
var fuse_array:Array = []

var game_pausable:bool = true
var pause_state:bool = false
var current_menu:Control = self


func _ready():
	menu_root.hide()
	credits_menu.hide()
	settings_menu.hide()
	pause_button.show()
	back_button.hide()
	fuse_array.append(fuse_1)
	fuse_array.append(fuse_2)
	fuse_array.append(fuse_3)

func update_inventory():
	var current_batteries:int = SaveManager.battery_count
	var old_batteries:int = battery_array.size()
	var difference = absi(current_batteries - old_batteries)
	if current_batteries > old_batteries:
		for i in difference:
			spawn_battery()
	if old_batteries > current_batteries:
		for i in difference:
			delete_battery()
	for i in fuse_array.size():
		if SaveManager.fuse_count > i:
			fuse_array[i].show()
			continue
		fuse_array[i].hide()
	
	

func spawn_battery():
	print("spawn battery")
	var battery_instance = battery_icon.instantiate()
	battery_array.append(battery_instance)
	battery_container.call_deferred("add_child",battery_instance)

func delete_battery():
	print("delete battery")
	battery_array[0].call_deferred("queue_free")
	battery_array.pop_front()





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
	update_inventory()
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
