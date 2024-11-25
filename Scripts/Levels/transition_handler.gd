extends CanvasModulate


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	SignalBus.level_start.connect(_on_level_start)
	SignalBus.level_end.connect(_on_level_end)


func _on_level_start():
	animation_player.play("fade_in")


func _on_level_end():
	animation_player.play("fade_out")


func _on_fade_out(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		SignalBus.transition_to_level.emit()
