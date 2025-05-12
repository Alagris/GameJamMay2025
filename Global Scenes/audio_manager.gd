extends Node

@export var UI_Hover_audio:AudioStreamPlayer2D
@export var UI_Pressed_audio:AudioStreamPlayer2D

var Master_Volume:float = 1.0
var SFX_Volume:float = 1.0
var Music_Volume:float = 1.0

@onready var current_music_stream:AudioStreamPlayer2D = $"Music Stream Organizer/Music 1"


func UI_Hover():
	UI_Hover_audio.play()

func UI_Pressed():
	UI_Pressed_audio.play()
