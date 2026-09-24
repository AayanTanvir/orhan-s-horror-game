extends Node3D

@export var character_name: String = "Friend"
@export var lines: Array[String] = [
	"Hey, you made it. The place looks a bit run down, doesn't it?",
	"Let's head inside before it gets too dark."
]

func interact():
	var dialogue_manager = get_tree().root.find_child("DialogueManager", true, false)
	if dialogue_manager:
		# Format lines for the dialogue system
		var formatted_lines = []
		for line in lines:
			formatted_lines.append({"speaker": character_name, "text": line})
		dialogue_manager.start_dialogue(formatted_lines)
