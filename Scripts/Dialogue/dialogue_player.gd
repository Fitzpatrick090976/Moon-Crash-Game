extends CanvasLayer


var current_line_index = 0
var dialogue_lines = []
var dialogue_playing = false
var current_key = ""
var dialogue_data = {}


@onready var label: Label = $TextureRect/Label
@onready var texture_rect: TextureRect = $TextureRect
@onready var type_writing_effect: AnimationPlayer = $TextureRect/Label/AnimationPlayer
@onready var choice_container: VBoxContainer = $TextureRect/ChoiceContainer



func _ready() -> void:
	SignalBus.show_dialogue.connect(_on_show_dialogue)
	texture_rect.visible = false
	choice_container.visible = false


func _on_show_dialogue(key, path):
	# LOAD NPC'S JSON & INIT DIALOGUE
	JsonManager.load_json(path) # Convert JSON to dict and store in JsonManager
	if JsonManager.data.has(key):
		current_key 	= key
		dialogue_data = JsonManager.data
		current_line_index = 0
		#dialogue_lines = JsonManager.data[key]
		show_current_line()
	else:
		push_error("dialogue_player: key does not exist in JSON file")

func show_current_line():
	var current_line = dialogue_data[current_key][current_line_index]
	
	if current_line["type"] == "text":
		# Display text line
		label.text = current_line["content"]
		type_writing_effect.play("type_writing_effect")
		texture_rect.visible = true
		dialogue_playing = true
	elif current_line["type"] == "choice":
		# Show choices
		display_choices(current_line["options"])
		
	# Initiate dialogue interaction
	#print(dialogue_lines[current_line_index])
	#texture_rect.visible = true
	#label.text = dialogue_lines[current_line_index]
	#type_writing_effect.play("type_writing_effect")
	#dialogue_playing = true
func display_choices(options):
	# Clear existing buttons
	for child in choice_container.get_children():
		child.queue_free()
		
	# Create buttons for each choice
	for option in options:
		var button = Button.new()
		button.text = option["text"]
		
		var next_key = option["next_key"]
		button.connect("pressed", Callable(self, "_on_choice_selected").bind(next_key))
		
		choice_container.add_child(button)
		
	# Show choice container
	choice_container.visible = true
	texture_rect.visible = true
	
func _on_choice_selected(next_key):
	# Advance dialogue to next key
	current_key = next_key
	current_line_index = 0
	choice_container.visible = false
	show_current_line()

func advance_dialogue():
	# ADVANCE AND QUIT DIALOGUE
	if dialogue_playing:
		current_line_index += 1
	
	if current_line_index >= dialogue_data[current_key].size():
		# End dialogue if out of bounds
		texture_rect.visible = false
		dialogue_playing = false
	else:
		show_current_line()
	# If out of bounds
	#if current_line_index > dialogue_lines.size() - 1:
		#dialogue_playing = false
		# TODO
		# Remove dialogue box sprite from screen
		#texture_rect.visible = false
		#current_line_index = 0 # Reset index for future interactions
	#else:
		#print(dialogue_lines[current_line_index])
		#texture_rect.visible = true
		#type_writing_effect.play("type_writing_effect")
		#label.text = dialogue_lines[current_line_index]

func _input(event):
	# While in dialogue,
	# detect input from user to advance or terminate dialogue
	if event.is_action_pressed("advance") and dialogue_playing:
		advance_dialogue()
