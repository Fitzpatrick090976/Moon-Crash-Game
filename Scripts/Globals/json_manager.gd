extends Node


# FOR PARSING, LOADING & SAVING


var data: Dictionary = {}
#var path: String = "res://Dialogue/JSON Files/debug_dialogue.json"


#func _ready() -> void:
	#data = load_json(path)
	
#func _ready() -> void:
	#data = load_json(path)
	#print(data)  # This should print the contents of the loaded JSON
	#pass


# CONVERT JSON FILE TO DICT (LOAD)
func load_json(file_path: String) -> Dictionary:
	if FileAccess.file_exists(file_path): # Check if file path is valid
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(data_file.get_as_text())
		if parsed_data is Dictionary:
			data = parsed_data
			return data
		else:
			push_error("load_json: parsed_data is not Dictionary")
			return {}
	else:
		push_error("load_json: file path does not exist")
		return {}
