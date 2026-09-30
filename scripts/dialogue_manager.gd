extends CanvasLayer

@export var label: Label
@export var panel: Panel


func _ready() -> void:
	label.text = ""
	panel.visible = false

func start_dialogue(lines: Array[Dictionary], char_name: String):
	panel.visible = true
	for line in lines:
		label.text = "%s: " % char_name + line.text if line.speaker == "char" else "You: " + line.text
		await get_tree().create_timer(4.0).timeout
	label.text = ""   
	panel.visible = false
	
