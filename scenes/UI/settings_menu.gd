extends Control

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")

@export var dialogue_speed:DIALOGUE_SPEED = DIALOGUE_SPEED.NORMAL
enum DIALOGUE_SPEED {SLOW,NORMAL,FAST}

func _ready():
	RenderingServer.set_default_clear_color(Color(0,0,0,1))

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID,linear_to_db(value))
	print(value)

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID,linear_to_db(value))

func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MASTER_BUS_ID,linear_to_db(value))

func _on_dialogue_speed_item_selected(index):
	match index:
		0:
			dialogue_speed = DIALOGUE_SPEED.SLOW
			DialogueManager.dialogue_speed = .1
		1:
			dialogue_speed = DIALOGUE_SPEED.NORMAL
			DialogueManager.dialogue_speed = .05
		2:
			dialogue_speed = DIALOGUE_SPEED.FAST
			DialogueManager.dialogue_speed = .01
