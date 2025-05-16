extends Node

@export var UI_Hover_audio:AudioStreamPlayer2D
@export var UI_Pressed_audio:AudioStreamPlayer2D

@onready var current_music_stream:AudioStreamPlayer2D = $"Music Stream Organizer/Music 1"

@export var ambiance_1:AudioStreamPlayer2D
@export var ambiance_2:AudioStreamPlayer2D
@export var ambiance_3:AudioStreamPlayer2D
var ambiance_array:Array = []

var play_spooky_ambiance:bool = true
var rng = RandomNumberGenerator.new()

func _ready():
	ambiance_array.append(ambiance_1)
	ambiance_array.append(ambiance_2)
	ambiance_array.append(ambiance_3)



func UI_Hover():
	UI_Hover_audio.play()

func UI_Pressed():
	UI_Pressed_audio.play()


func _on_ambiance_timer_timeout():
	$"Ambiance Organizer/ambiance timer".wait_time = rng.randf_range(10.0,40.0)
	if play_spooky_ambiance:
		ambiance_array.pick_random().play()
		
