extends Node2D


@export var curr_level: String
@export var next_level: PackedScene


func _ready() -> void:
	SignalBus.transition_to_level.connect(_on_transition_to_level)
	SignalBus.level_start.emit(curr_level)


func _on_transition_to_level():
	get_tree().change_scene_to_packed(next_level)
