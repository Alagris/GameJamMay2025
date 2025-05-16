extends Node

@export var player:CharacterBody2D
@export var teleport_position_basement:Node2D


func trigger_teleport(body,location_node:Node2D):
	if body != player:
		return
	player.teleport(location_node.global_position)

func _on_teleport_to_basement_body_entered(body):
	trigger_teleport(body,teleport_position_basement)
