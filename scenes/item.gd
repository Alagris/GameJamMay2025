extends Area2D
class_name Item

@onready var player = get_tree().get_first_node_in_group("player")
@export var action_name:String = "Pick up"
@export var requires_power:bool = false
@export var currently_active:bool = true


var interact:Callable = func():
	get_parent().interact()
	

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		print("register area")
		InteractionManager.register_area(self)
	

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		print("unregister area")
		InteractionManager.unregister_area(self)
	
