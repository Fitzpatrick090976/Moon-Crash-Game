extends Area2D


@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


var player_prev_position: Vector2 # I.E. "WHAT DIRECTION DID THEY ENTER FROM?"


func _on_door_area_entered(area: Area2D) -> void:
	# HORIZONTAL
	# IF PLAYER ABOVE
	if area.global_position.y < global_position.y:
		animation_player.play("open_above")
	# ELSE IF BELOW
	elif area.global_position.y > global_position.y:
		animation_player.play("open_below")
	player_prev_position = area.global_position


func _on_door_area_exited(area: Area2D) -> void:
	# HORIZONTAL
	# IF PLAYER ABOVE
	if area.global_position.y < global_position.y:
		# IF ENTERED FROM ABOVE
		if player_prev_position.y < global_position.y:
			animation_player.play("close_above")
		else:
			animation_player.play("close_below")
	# ELSE IF BELOW
	elif area.global_position.y > global_position.y:
		# IF ENTERED FROM BELOW
		if player_prev_position.y > global_position.y:
			animation_player.play("close_below")
		else:
			animation_player.play("close_above")
