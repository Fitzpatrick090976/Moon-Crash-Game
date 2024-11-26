extends Camera2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer


const LERP_SPEED = 0.25


var interpolation:= false
var t:= 0.0
var src: Vector2
var dest: Vector2


func _ready() -> void:
	SignalBus.lerp_camera.connect(_on_lerp_camera)
	SignalBus.moon_encounter_start.connect(_on_moon_encounter_start)


func _on_lerp_camera(dest_position: Vector2):
	t = 0.0
	src = global_position
	dest = dest_position
	interpolation = true


func _physics_process(delta: float) -> void:
	# INTERPOLATION
	if interpolation:
		t += delta * LERP_SPEED
		global_position = src.lerp(dest, t)
		if t >= 1.0:
			interpolation = false
			SignalBus.lerp_camera_finished.emit()


func _on_moon_encounter_start():
	animation_player.play("moon_encounter_start")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "moon_encounter_start":
		var path = "res://Dialogue/JSON Files/Cutscenes/moon_encounter.json"
		var key = CharacterKeyManager.manager[path]["moon_encounter"]
		SignalBus.show_dialogue.emit(key, path)
