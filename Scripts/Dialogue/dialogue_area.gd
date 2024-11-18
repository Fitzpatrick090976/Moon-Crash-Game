extends Area2D


var my_dialogue_playing := false


func _ready() -> void:
	SignalBus.choice_selected.connect(_on_choice_selected)
	SignalBus.terminate_dialogue.connect(_on_terminate_dialogue)


# INIT DIALOGUE


@export var dialogue_key: String
@export var dialogue_path: String  # Path to each NPC's unique JSON file


func _input(event: InputEvent) -> void:
	if mouse_colliding and player_colliding and event.is_action_pressed("left_click"):
		SignalBus.emit_signal("show_dialogue", dialogue_key, dialogue_path)
		my_dialogue_playing = true


# DETECT USER MOUSE MOVEMENT


var mouse_colliding = false


func _on_mouse_entered() -> void:
	mouse_colliding = true


func _on_mouse_exited() -> void:
	mouse_colliding = false


# DETECT IF PLAYER IN RANGE


var player_colliding = false


func _on_area_entered(area: Area2D) -> void:
	player_colliding = true


func _on_area_exited(area: Area2D) -> void:
	player_colliding = false


# CHOICE SELECTION REACTION

func _on_choice_selected(response_key: String):
	var json = JsonManager.load_json(dialogue_path)
	if json.has(response_key):
		dialogue_key = response_key
	# CONTINUE DIALOGUE IF I AM THE SPEAKER
	if my_dialogue_playing:
		SignalBus.emit_signal("show_dialogue", dialogue_key, dialogue_path)


# TERMINATE DIALOGUE

func _on_terminate_dialogue():
	my_dialogue_playing = false
