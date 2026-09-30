extends Node3D


@export var dialogue_panel: Panel
@export var dialogue_label: Label

func _ready():
	# Hide the dialogue box when the game starts
	dialogue_panel.visible = false

func _on_forest_trigger_body_entered(body):
	# Check if the player crossed the line
	if body is Player:
		show_dialogue("Friend: Yo, let's go hiking in those woods everyone's been talking about.")

func show_dialogue(text: String):
	dialogue_label.text = text
	dialogue_panel.visible = true
	
	# Wait 4 seconds, then hide the dialogue text automatically
	await get_tree().create_timer(4.0).timeout
	dialogue_panel.visible = false
