extends Button

func _on_pressed():
	AudioManager.UI_Pressed()

func _on_mouse_entered():
	AudioManager.UI_Hover()
