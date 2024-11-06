extends CharacterBody2D


const SPEED = 150.0


var is_walking = false


@onready var animated_sprite_2d: AnimatedSprite2D = $RotationMarker/AnimatedSprite2D


func _physics_process(delta: float) -> void:

	var x_direction := Input.get_axis("left", "right")
	var y_direction := Input.get_axis("up", "down")
	
	if x_direction or y_direction:
		velocity.x = x_direction * SPEED
		velocity.y = y_direction * SPEED
		is_walking = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		is_walking = false
	
	if is_walking:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")

	move_and_slide()
