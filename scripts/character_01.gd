extends Node3D

@export var character_name: String = "Friend"
@export var lines: Array[Dictionary] = [
	{ "speaker": "char", "text": "..." },
	{ "speaker": "user", "text": "WHO ARE YOU" }
]

func interact():
	var dialogue_manager = get_tree().root.find_child("DialogueManager", true, false)
	if dialogue_manager:
		dialogue_manager.start_dialogue(lines, character_name)
