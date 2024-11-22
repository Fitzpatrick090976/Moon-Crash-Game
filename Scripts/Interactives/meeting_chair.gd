extends Node2D


func _ready() -> void:
	SignalBus.init_cutscene.connect(_on_init_cutscene)


func _on_init_cutscene():
	SignalBus.lerp_player.emit(global_position)
