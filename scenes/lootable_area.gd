extends Node2D

var is_looted:bool = false
@onready var player = get_tree().get_first_node_in_group("player")


func _ready():
	pass




func interact():
	player.loot(self)


func looted():
	is_looted = true
	$Area2D.currently_active = false
