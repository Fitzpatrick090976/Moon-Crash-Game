extends Area2D


@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


func _on_player_entered(area: Area2D) -> void:
	animation_player.play("open")


func _on_player_exited(area: Area2D) -> void:
	animation_player.play("close")
