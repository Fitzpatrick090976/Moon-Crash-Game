extends CanvasLayer


var current_line_index = 0
var dialogue_lines = []
var dialogue_playing = false


@onready var label: Label = $TextureRect/Label
@onready var texture_rect: TextureRect = $TextureRect
@onready var type_writing_effect: AnimationPlayer = $TextureRect/Label/AnimationPlayer


func _ready() -> void:
	SignalBus.show_dialogue.connect(_on_show_dialogue)
	texture_rect.visible = false


func _on_show_dialogue(key, path):
	# LOAD NPC'S JSON & INIT DIALOGUE
	JsonManager.load_json(path)
	if JsonManager.data.has(key):
		dialogue_lines = JsonManager.data[key]
		show_current_line()
	else:
		push_error("dialogue_player: key does not exist in JSON file")

func show_current_line():
	# Initiate dialogue interaction
	#print(dialogue_lines[current_line_index])
	texture_rect.visible = true
	label.text = dialogue_lines[current_line_index]
	type_writing_effect.play("type_writing_effect")
	dialogue_playing = true
	
	

func advance_dialogue():
	# ADVANCE AND QUIT DIALOGUE
	current_line_index += 1
	# If out of bounds
	if current_line_index > dialogue_lines.size() - 1:
		dialogue_playing = false
		# TODO
		# Remove dialogue box sprite from screen
		texture_rect.visible = false
		current_line_index = 0 # Reset index for future interactions
	else:
		#print(dialogue_lines[current_line_index])
		texture_rect.visible = true
		type_writing_effect.play("type_writing_effect")
		label.text = dialogue_lines[current_line_index]

func _input(event):
	# While in dialogue,
	# detect input from user to advance or terminate dialogue
	if event.is_action_pressed("advance") and dialogue_playing:
		advance_dialogue()
