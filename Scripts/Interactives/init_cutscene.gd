extends Area2D


func _on_body_entered(body: Node2D) -> void:
	SignalBus.moon_encounter_start.emit()
	SignalBus.lerp_player.emit(get_parent().global_position)
	SignalBus.choice_selected.connect(_on_choice_selected)


func _on_choice_selected(response_key: String):
	var path = "res://Dialogue/JSON Files/Cutscenes/moon_encounter.json"
	SignalBus.show_dialogue.emit(response_key, path)
