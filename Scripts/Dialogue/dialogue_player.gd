extends CanvasLayer

var current_line_index = 0
var dialogue_lines = []

func _ready() -> void:
	SignalBus.show_dialogue.connect(_on_show_dialogue)
	#print(get_tree().current_scene.default_dialogue())  # default dialogue

func _on_show_dialogue(key):
	#var json_path = "res://Dialogue/JSON Files/scientist.json"
	#JsonManager.load_json(json_path)
	# Debug: loaded JSON data
	#print("Loaded JSON data:", JsonManager.data)
	
	# Load dialogue lines for the given key
	if JsonManager.data.has(key):
		dialogue_lines = JsonManager.data[key]
		current_line_index = 0
		show_current_line()  # Show the first line
	else:
		print("Key not found in JSON data:", key)

func show_current_line():
	# Display the current line or signal the end of dialogue
	if current_line_index < dialogue_lines.size():
		print(dialogue_lines[current_line_index]) # Display the current line
		current_line_index += 1
	#else:
		#print("End of dialogue.")

func advance_dialogue():
	# Move to the next line if there are more lines
	if current_line_index < dialogue_lines.size() - 1:
		current_line_index += 1
		show_current_line()
	#else:
		#print("End of dialogue.")  # Only printed once when dialogue ends

func _input(event):
	# Detect left-click to advance dialogue
	if event.is_action_pressed("left_click"):
		advance_dialogue()
