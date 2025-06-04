extends Node2D

@export var fuse_in_sound:AudioStreamPlayer2D
@export var fuse_out_sound:AudioStreamPlayer2D

@export var fuse_1_texture:TextureRect
@export var fuse_2_texture:TextureRect
@export var fuse_3_texture:TextureRect
var fuse_array:Array = []
var fuse_count:int = 0

func _ready():
	fuse_array.append(fuse_1_texture)
	fuse_array.append(fuse_2_texture)
	fuse_array.append(fuse_3_texture)
	for i in fuse_array.size():
		fuse_array[i].self_modulate = Color(0.1,0.1,0.1,1)
	#deactivate_power()


func interact():
	if SaveManager.fuse_count > 0:
		SaveManager.fuse_count -= 1
		fuse_array[fuse_count].self_modulate = Color(1,1,1,1)
		fuse_count += 1
		fuse_out_sound.play()
	if fuse_count == 3:
		$Area2D.currently_active = false
		activate_power()

func deactivate_power():
	print("deactivate power")
	InteractionManager.power_on = false
	var powered_objects:Array = InteractionManager.powered_objects.duplicate(true)
	for i in powered_objects.size():
		powered_objects[i].power_off()

func activate_power():
	print("activate power")
	InteractionManager.power_on = true
	var powered_objects:Array = InteractionManager.powered_objects.duplicate(true)
	for i in powered_objects.size():
		powered_objects[i].power_on()
