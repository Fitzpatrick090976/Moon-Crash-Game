extends Node


var manager = {
	
	# CHARACTERS
	
	"res://Dialogue/JSON Files/Characters/blue.json": {
		"day_one": "blue-day_one-default",
		"day_two": "",
		"day_three": "",
	},
	"res://Dialogue/JSON Files/Characters/cyan.json": {
		"day_one": "cyan-day_one-default",
		"day_two": "",
		"day_three": "",
	},
	"res://Dialogue/JSON Files/Characters/green.json": {
		"day_one": "green-day_one-default",
		"day_two": "",
		"day_three": "",
	},
	"res://Dialogue/JSON Files/Characters/magenta.json": {
		"day_one": "magenta-day_one-default",
		"day_two": "",
		"day_three": "",
	},
	"res://Dialogue/JSON Files/Characters/mint.json": {
		"day_one": "mint-day_one-default",
		"day_two": "",
		"day_three": "",
	},
	"res://Dialogue/JSON Files/Characters/orange.json": {
		"day_one": "orange-day_one-default",
		"day_two": "",
		"day_three": "",
	},
	"res://Dialogue/JSON Files/Characters/purple.json": {
		"day_one": "purple-day_one-default",
		"day_two": "",
		"day_three": "",
	},
	"res://Dialogue/JSON Files/Characters/red.json": {
		"day_one": "red-day_one-default",
		"day_two": "",
		"day_three": "",
	},
	"res://Dialogue/JSON Files/Characters/yellow.json": {
		"day_one": "yellow-day_one-default",
		"day_two": "",
		"day_three": "",
	},
	
	# CUTSCENES
	
	"res://Dialogue/JSON Files/Cutscenes/meeting_day_one.json": {
		"day_one": "",
	},
	"res://Dialogue/JSON Files/Cutscenes/meeting_day_two.json": {
		"day_two": "",
	},
	"res://Dialogue/JSON Files/Cutscenes/meeting_day_three.json": {
		"day_three": "",
	},
	"res://Dialogue/JSON Files/Cutscenes/moon_encounter.json": {
		
	},
	
	# TEXT
	
	"res://Dialogue/JSON Files/Text/text_day_one.json": {
		"day_one": "text_day_one-default",
	},
	"res://Dialogue/JSON Files/Text/text_day_two.json": {
		"day_two": "",
	},
	"res://Dialogue/JSON Files/Text/text_day_three.json": {
		"day_three": "",
	}
	
}


func _ready() -> void:
	SignalBus.update_character_key_manager.connect(_on_update_character_key_manager)


func _on_update_character_key_manager(update: String, dest: String):
	for character in manager.keys():
		if manager[character].has(dest):
			manager[character][dest] = update
