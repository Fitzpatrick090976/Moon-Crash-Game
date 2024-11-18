extends CanvasLayer


@onready var text_label: Label = $MarginContainer/MarginContainer/Label
@onready var choice_1: Button = $MarginContainer/MarginContainer/VBoxContainer/Choice1
@onready var choice_2: Button = $MarginContainer/MarginContainer/VBoxContainer/Choice2




var curr_key: String
var dialogue_dict: Dictionary
var curr_line_count := 0
var curr_line: Dictionary
var dialogue_playing := false
var choice_playing := false


func _ready() -> void:
	SignalBus.show_dialogue.connect(_on_show_dialogue)
	visible = false # INIT TO INVISIBLE
	text_label.visible = false
	choice_1.visible = false
	choice_2.visible = false


func _on_show_dialogue(key: String, path: String):
	var json = JsonManager.load_json(path)
	if json.has(key):
		curr_key = key
		dialogue_dict = json # dialogue_dict
		curr_line_count = 0 # RESET INDEX
		show_curr_line()


func show_curr_line():
	# dialogue_dict is dictionary containing collection of keys,
	# where each key is a specific interaction
	
	# Each key is connected to a list,
	# each element of which is a dictionary with two keys:
	# the "type" (e.g. text), which will inform Godot what to expect,
	# and the "content", i.e. what to display to screen
	
	curr_line = dialogue_dict[curr_key][curr_line_count]
	
	if curr_line["type"] == "text":
		# DISPLAY TEXT
		dialogue_playing = true
		choice_playing = false
		visible = true
		text_label.visible = true
		choice_1.visible = false
		choice_2.visible = false
		text_label.text = curr_line["text"]
	elif curr_line["type"] == "choice":
		# DISPLAY CHOICE
		dialogue_playing = false
		choice_playing = true
		visible = true
		text_label.visible = false
		choice_1.visible = true
		choice_2.visible = true
		choice_1.text = curr_line["choice"][0]["answer"]
		choice_2.text = curr_line["choice"][1]["answer"]


func advance_to_next_line():
	curr_line_count += 1
	# CHECK IF OUT OF BOUNDS
	if curr_line_count == dialogue_dict[curr_key].size():
		# TERMINATE DIALOGUE
		dialogue_playing = false
		choice_playing = false
		visible = false
		text_label.visible = false
		choice_1.visible = false
		choice_2.visible = false
		SignalBus.terminate_dialogue.emit()
	# ELSE SHOW CURRENT LINE
	else:
		show_curr_line()


func _input(event: InputEvent) -> void:
	# REGISTER INPUT TO ADVANCE & TERMINATE DIALOGUE
	if event.is_action_pressed("advance"):
		if dialogue_playing:
			advance_to_next_line()


func _on_choice_1_pressed() -> void:
	# GET RESPONSE KEY
	var response_key = curr_line["choice"][0]["response"]
	# EMIT SIGNAL TO ALL NPCS TO CHECK IF THEY HAVE RESPONSE KEY
	SignalBus.choice_selected.emit(response_key)

func _on_choice_2_pressed() -> void:
	# GET RESPONSE KEY
	var response_key = curr_line["choice"][1]["response"]
	# EMIT SIGNAL TO ALL NPCS TO CHECK IF THEY HAVE RESPONSE KEY
	SignalBus.choice_selected.emit(response_key)
