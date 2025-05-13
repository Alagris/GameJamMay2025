extends Area2D
class_name Item

@export var action_name:String = "Pick up"

var interact:Callable = func():
	pass
	

func _on_body_entered(body: Node2D) -> void:
	InteractionManager.register_area(self)
	pass

func _on_body_exited(body: Node2D) -> void:
	InteractionManager.unregister_area(self)
	pass
