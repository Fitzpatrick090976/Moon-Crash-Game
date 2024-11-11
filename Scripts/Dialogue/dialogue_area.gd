extends Area2D


# INIT DIALOGUE


@export var dialogue_key: String
@export var dialogue_path: String  # Path to each NPC's unique JSON file


func _input(event: InputEvent) -> void:
	if mouse_colliding and player_colliding and event.is_action_pressed("left_click"):
		JsonManager.load_json(dialogue_path)  # Load the specific NPC's dialogue
		SignalBus.emit_signal("show_dialogue", dialogue_key)


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
