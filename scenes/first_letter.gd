extends Node2D

@onready var player = DialogueManager.CHARACTER_TALKING.PLAYER
@onready var npc = DialogueManager.CHARACTER_TALKING.NPC

func interact():
	DialogueManager.play_dialogue(item_dialogue)

@onready var item_dialogue:Array = [
[player,npc],#this dictates what sprite comes on screen

[[player],#give focus to this character
[
""" Test Line 1
 Test Line 2
 Test Line 3
 Test Line 4
 Test Line 5
 Test Line 6
"""
]],#this is the end of this stack of text

[[npc],
[
""" Test Line 1
 Test Line 2
 Test Line 3
 Test Line 4
 Test Line 5
 Test Line 6
"""
]],

[[player],
[
""" Test Line 1
 Test Line 2
 Test Line 3
 Test Line 4
 Test Line 5
 Test Line 6
"""
]],

]#end array package
