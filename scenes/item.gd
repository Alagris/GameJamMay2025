extends Area2D
class_name Item

@export var action_name:String = "Pick up"
@export var requires_power:bool = false
@export var currently_active:bool = true


var interact:Callable = func():
	get_parent().interact()
	

func _on_body_entered(body: Node2D) -> void:
	print("register area")
	InteractionManager.register_area(self)
	

func _on_body_exited(body: Node2D) -> void:
	print("unregister area")
	InteractionManager.unregister_area(self)
	
