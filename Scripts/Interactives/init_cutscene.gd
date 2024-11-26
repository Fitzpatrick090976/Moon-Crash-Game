extends Area2D


func _on_body_entered(body: Node2D) -> void:
	SignalBus.moon_encounter_start.emit()
	SignalBus.lerp_player.emit(get_parent().global_position)
