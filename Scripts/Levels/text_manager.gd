extends Node2D


# ALL TEXT IS VISIBLE BY DEFAULT
# WHEN SIGNAL RECEIVED, MAKE ALL TEXT INVISIBLE


func _on_terminate_cutscene():
	for child in get_children():
		child.visible = false


# SET TEXT


@export var current_level: String
@export var dialogue_key: String
@export var dialogue_path: String


func _ready() -> void:
	SignalBus.terminate_cutscene.connect(_on_terminate_cutscene)
	# RETRIEVE CURR KEY FROM MANAGER BASED ON CURR LEVEL
	if dialogue_key == "": # IF NOT MANUALLY CONFIGURED
		dialogue_key = CharacterKeyManager.manager[dialogue_path][current_level]
	var json = JsonManager.load_json(dialogue_path)
	var line_count = 0
	if json.has(dialogue_key):
		for text in get_children():
			for label in text.get_children():
				if label is Label:
					label.text = json[dialogue_key][line_count]["text"]
					line_count += 1
