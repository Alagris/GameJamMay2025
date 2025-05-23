extends Node

var player_character:CharacterBody2D
var flashlight:Node2D

var can_control_player:bool = true

func _ready():
	pass

func new_player_instance():
	can_control_player = true

func _physics_process(delta):
	if is_instance_valid(player_character) == false:
		print("player instance invalid")
		return
	match can_control_player:
		true:
			player_character.going_down = Input.is_action_pressed("down")
			player_character.going_left = Input.is_action_pressed("left")
			player_character.going_right = Input.is_action_pressed("right")
			player_character.going_up = Input.is_action_pressed("up")
		false:
			player_character.going_up = false
			player_character.going_down = false
			player_character.going_left = false
			player_character.going_right = false
