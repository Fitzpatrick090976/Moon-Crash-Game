extends Camera2D


const LERP_SPEED = 0.25


var interpolation:= false
var t:= 0.0
var src: Vector2
var dest: Vector2


func _ready() -> void:
	SignalBus.lerp_camera.connect(_on_lerp_camera)


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
