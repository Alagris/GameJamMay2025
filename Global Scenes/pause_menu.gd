extends Control

var game_pausable:bool = false
var pause_state:bool = false

var escape_method:String

func _ready():
	hide()

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

func escape_requested():
	call(escape_method)





func _on_title_screen_pressed():
	pause_deactivate()
	#SceneManager.load_title_screen()

func pause_activate():
	self.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	pause_state = true

func pause_deactivate():
	self.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	pause_state = false
