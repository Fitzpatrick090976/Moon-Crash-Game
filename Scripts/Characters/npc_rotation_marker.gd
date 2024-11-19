extends Marker2D


var current_player_position: Vector2


func _ready() -> void:
	SignalBus.get_player_position.connect(_on_get_player_position)


func _on_get_player_position(player_position):
	current_player_position = player_position


func _physics_process(delta: float) -> void:
	look_at(current_player_position)
