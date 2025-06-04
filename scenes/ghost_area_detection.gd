extends Area2D

@export var ghost_light_target:Node2D


func _ready():
	self.add_to_group("ghost attack area")
