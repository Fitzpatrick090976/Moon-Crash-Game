extends CharacterBody2D


func _ready() -> void:
	SignalBus.init_dialogue.connect(_on_init_dialogue)
	SignalBus.terminate_dialogue.connect(_on_terminate_dialogue)
	SignalBus.lerp_player.connect(_on_lerp_player)
	SignalBus.terminate_cutscene.connect(_on_terminate_cutscene)
	SignalBus.level_end.connect(_on_level_end)
	SignalBus.moon_encounter_start.connect(_on_moon_encounter_start)


const SPEED = 150.0
const LERP_SPEED = 0.5


var is_walking:= false
var dialogue_playing:= false
var cutscene_playing:= false
var can_move:= true
var interpolation:= false
var t:= 0.0
var src: Vector2
var dest: Vector2


@onready var animated_sprite_2d: AnimatedSprite2D = $RotationMarker/AnimatedSprite2D


func _physics_process(delta: float) -> void:
	
	
	# EMIT POSITION SIGNAL
	SignalBus.get_player_position.emit(global_position)
	
	
	# ALLOW MOVEMENT IF NO DIALOGUE IS PLAYING
	if can_move:
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
	
	
	# INTERPOLATION
	elif interpolation:
		t += delta * LERP_SPEED
		global_position = src.lerp(dest, t)
		if t >= 1.0:
			interpolation = false
			SignalBus.lerp_player_finished.emit()


func _on_init_dialogue():
	dialogue_playing = true
	can_move = false


func _on_terminate_dialogue():
	dialogue_playing = false
	can_move = true


func _on_lerp_player(dest_position: Vector2):
	t = 0.0
	src = global_position
	dest = dest_position
	interpolation = true


func _on_terminate_cutscene():
	SignalBus.lerp_camera.emit(global_position)


func _on_level_end():
	can_move = false


func _on_moon_encounter_start():
	can_move = false
