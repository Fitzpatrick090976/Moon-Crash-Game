extends CanvasLayer


@onready var text_label: Label = $MarginContainer/MarginContainer/Label
@onready var choice_1: Button = $MarginContainer/MarginContainer/VBoxContainer/Choice1
@onready var choice_2: Button = $MarginContainer/MarginContainer/VBoxContainer/Choice2
@onready var panel: Panel = $MarginContainer/Panel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var curr_key: String
var dialogue_dict: Dictionary
var curr_line_count := 0
var curr_line: Dictionary
var dialogue_playing := false
var choice_playing := false


func _ready() -> void:
	SignalBus.show_dialogue.connect(_on_show_dialogue)
	SignalBus.lerp_player_finished.connect(_on_lerp_player_finished)
	SignalBus.lerp_camera_finished.connect(_on_lerp_camera_finished)
	visible = false # INIT TO INVISIBLE
	text_label.visible = false
	choice_1.visible = false
	choice_2.visible = false


func _on_show_dialogue(key: String, path: String):
	SignalBus.init_dialogue.emit()
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
		
		
		# CHECK FOR SPEAKER'S IDENTITY
		if curr_line.has("speaker"):
			var color = curr_line["speaker"]
			text_label.set("theme_override_colors/font_color", color_dict[color])
			#panel.set("theme_override_styles/panel/border_color", color_dict[color])
			#var new_stylebox_normal = panel.get_theme_stylebox("normal").duplicate()
			#new_stylebox_normal.border_color = color_dict[color]
			#panel.add_theme_stylebox_override("normal", new_stylebox_normal)

		else:
			text_label.set("theme_override_colors/font_color", color_dict["white"])
			#panel.set("border_color", color_dict["white"])
			#var new_stylebox_normal = panel.get_theme_stylebox("normal").duplicate()
			#new_stylebox_normal.border_color = color_dict["white"]
			#panel.add_theme_stylebox_override("normal", new_stylebox_normal)
		
		
		# DISPLAY TEXT
		dialogue_playing = true
		choice_playing = false
		visible = true
		text_label.visible = true
		choice_1.visible = false
		choice_2.visible = false
		text_label.text = curr_line["text"]
		animation_player.play("typing animation")
		
		
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
	
	
	elif curr_line["type"] == "cmd":
		var cmd = curr_line["cmd"]
		if cmd == "start":
			is_player_interpolating = true
			is_camera_interpolating = true
			visible = false
			SignalBus.init_cutscene.emit()
		elif cmd == "end":
			is_camera_interpolating = true
			visible = false
			SignalBus.terminate_cutscene.emit()
		elif cmd == "replace":
			var response_key = curr_line["replace"]
			SignalBus.choice_selected.emit(response_key)
		elif cmd == "transition":
			visible = false
			SignalBus.level_end.emit()
		elif cmd == "update":
			SignalBus.update_character_key_manager.emit(curr_line["update"], curr_line["dest"])
			advance_to_next_line()

func advance_to_next_line():
	curr_line_count += 1
	# CHECK IF OUT OF BOUNDS
	if curr_line_count == dialogue_dict[curr_key].size():
		# TERMINATE DIALOGUE
		terminate_dialogue()
	# ELSE SHOW CURRENT LINE
	else:
		show_curr_line()


func _input(event: InputEvent) -> void:
	# REGISTER INPUT TO ADVANCE & TERMINATE DIALOGUE
	if event.is_action_pressed("advance"):
		if not is_player_interpolating and not is_camera_interpolating:
			if dialogue_playing:
				advance_to_next_line()


func _on_choice_1_pressed() -> void:	
	button_manager(0)


func _on_choice_2_pressed() -> void:
	button_manager(1)


func button_manager(index: int):
	# GET RESPONSE KEY
	var response_key = curr_line["choice"][index]["response"]
	# CHECK FOR NO RESPONSE
	if response_key == "none":
		terminate_dialogue()
	# EMIT SIGNAL TO ALL NPCS TO CHECK IF THEY HAVE RESPONSE KEY
	else:
		SignalBus.choice_selected.emit(response_key)


func terminate_dialogue():
	dialogue_playing = false
	choice_playing = false
	visible = false
	text_label.visible = false
	choice_1.visible = false
	choice_2.visible = false
	SignalBus.terminate_dialogue.emit()


var color_dict: Dictionary = {
	"white": Color(1, 1, 1),
	"blue": Color(0.18, 0.41, 0.74),
	"cyan": Color(0.18, 0.74, 0.74),
	"green": Color(0.30, 0.74, 0.18),
	"magenta": Color(0.63, 0.18, 0.74),
	"mint": Color(0.45, 0.90, 0.63),
	"orange": Color(0.90, 0.57, 0.09),
	"purple": Color(0.30, 0.18, 0.74),
	"red": Color(0.74, 0.18, 0.18),
	"yellow": Color(0.90, 0.81, 0.09),
}


# HANDLE INTERPOLATION

var is_player_interpolating:= false
var is_camera_interpolating:= false


func _on_lerp_player_finished():
	is_player_interpolating = false
	if not is_camera_interpolating:
		advance_to_next_line()


func _on_lerp_camera_finished():
	is_camera_interpolating = false
	if not is_player_interpolating:
		advance_to_next_line()
