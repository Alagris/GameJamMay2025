extends Control

@export var transform_control:Control
@export var text_display:RichTextLabel
@export var dialogue_box:PanelContainer
@export var text_noise:AudioStreamPlayer2D

@export var NPC_nameplate:Label
@export var npc_sprite:Sprite2D

@export var player_nameplate:Label
@export var player_sprite:Sprite2D


@export var intro_list:Node
enum DIALOGUE_LIST {INTRO}

var character_talking:CHARACTER_TALKING = CHARACTER_TALKING.NOBODY
enum CHARACTER_TALKING {PLAYER,NPC,NOBODY}

var dialogue_box_on:bool = false
var dialogue_speed:float = 0.05

var current_stack:int = 0
var end_of_text:bool = false
var text_stack_size:int = 0
var text_stack:Array = []




func _ready():
	transform_control.hide()
	player_sprite.hide()
	player_nameplate.hide()
	NPC_nameplate.hide()
	await get_tree().create_timer(2,true).timeout
	
	play_dialogue(DIALOGUE_LIST.INTRO,0)


func change_npc_name(input_name:String):
	NPC_nameplate.text = input_name

func _physics_process(delta):
	if dialogue_box_on == false:
		return
	if Input.is_action_just_pressed("speed up text"):
		print("speed up text")
		match end_of_text:
			true:
				print("next stack")
				next_stack()
			false:
				print("skip to end of dialogue")
				end_of_text = true
				text_display.set_visible_ratio(1.0)

func next_stack():
	if current_stack + 1 == text_stack_size:
		close_dialogue()
		return
	current_stack += 1
	display_text()

func display_text():
	match text_stack[current_stack][0]:
		CHARACTER_TALKING.NPC:
			focus_character(CHARACTER_TALKING.NPC)
		CHARACTER_TALKING.PLAYER:
			focus_character(CHARACTER_TALKING.PLAYER)
	end_of_text = false
	print(text_stack[current_stack][1][0])
	text_display.text = text_stack[current_stack][1][0]
	text_display.set_visible_ratio(0.0)
	
	var characters:int = text_display.get_total_character_count()
	for i in characters:
		if end_of_text == true:
			return
		text_display.set_visible_characters(i)
		await get_tree().create_timer(dialogue_speed,true).timeout
	end_of_text = true

func play_dialogue(dialogue_list:DIALOGUE_LIST,index:int):
	print("play dialogue requested")
	var selected_dialogue_list:Node
	match dialogue_list:
		DIALOGUE_LIST.INTRO:
			selected_dialogue_list = intro_list
	
	text_stack = selected_dialogue_list.dialogue_array[index].duplicate(true)
	print(text_stack)
	text_stack_size = (text_stack.size() - 1)
	current_stack = 0
	dialogue_box_on = true
	text_display.text = ""
	
	await box_open()
	for i in text_stack[0].size():
		match text_stack[0][i]:
			CHARACTER_TALKING.PLAYER:
				enter_sprite("left",player_sprite)
			CHARACTER_TALKING.NPC:
				enter_sprite("left",npc_sprite)
			
	text_stack.pop_front()
	display_text()
	print("opening dialogue complete")

func close_dialogue():
	print("closing dialogue requested")
	dialogue_box_on = false
	
	character_talking = CHARACTER_TALKING.NOBODY
	
	exit_sprite("left",player_sprite)
	exit_sprite("right",npc_sprite)
	
	await box_close()
	await get_tree().create_timer(.5,true).timeout
	text_stack.clear()
	print("closeing dialogue complete")

func box_open():
	print("box open requested")
	transform_control.show()
	var tween = create_tween()
	tween.tween_property(transform_control,"position",Vector2(0,0),0.5)

func box_close():
	print("box close request")
	var tween = create_tween()
	tween.tween_property(transform_control,"position",Vector2(0,300),0.5)
	close_nameplate(NPC_nameplate)
	close_nameplate(player_nameplate)
	await get_tree().create_timer(.5,true).timeout
	transform_control.hide()
	player_nameplate.hide()
	NPC_nameplate.hide()

func focus_character(selected_character:CHARACTER_TALKING):
	if character_talking == selected_character:
		return
	character_talking = selected_character
	match selected_character:
		CHARACTER_TALKING.NPC:
			player_sprite.set_self_modulate(Color(1,1,1,1).darkened(0.6))
			npc_sprite.set_self_modulate(Color(1,1,1,1).darkened(0.0))
			open_nameplate(NPC_nameplate)
			close_nameplate(player_nameplate)
		CHARACTER_TALKING.PLAYER:
			player_sprite.set_self_modulate(Color(1,1,1,1).darkened(0.0))
			npc_sprite.set_self_modulate(Color(1,1,1,1).darkened(0.6))
			open_nameplate(player_nameplate)
			close_nameplate(NPC_nameplate)

func close_nameplate(nameplate_refrence:Control):
	var relative_position:Vector2 = Vector2(nameplate_refrence.position.x,500)
	var tween = create_tween()
	tween.tween_property(nameplate_refrence,"position",relative_position,0.5)
	await get_tree().create_timer(.5,true).timeout
	nameplate_refrence.hide()

func open_nameplate(nameplate_refrence:Control):
	var relative_position:Vector2 = Vector2(nameplate_refrence.position.x,456)
	nameplate_refrence.show()
	var tween = create_tween()
	tween.tween_property(nameplate_refrence,"position",relative_position,0.5)

func enter_sprite(left_or_right:String,selected_sprite:Sprite2D):
	if not is_instance_valid(selected_sprite):
		print("sprite invalid")
		return
	print("enter sprite requested")
	var tween = create_tween()
	var end_position:Vector2
	match left_or_right:
		"left":
			end_position = Vector2(180,270)
		"right":
			end_position
	selected_sprite.show()
	tween.tween_property(selected_sprite,"position",end_position,0.5)
	print("enter sprite complete")

func exit_sprite(left_or_right:String,selected_sprite:Sprite2D):
	if not is_instance_valid(selected_sprite):
		print("sprite invalid")
		return
	print("exit sprite requested")
	var tween = create_tween()
	var end_position:Vector2
	match left_or_right:
		"left":
			end_position = Vector2(-180,270)
		"right":
			end_position
	tween.tween_property(selected_sprite,"position",end_position,0.5)
	await get_tree().create_timer(.5,true).timeout
	selected_sprite.hide()
	print("exit sprite complete")
