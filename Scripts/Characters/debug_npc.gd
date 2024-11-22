extends CharacterBody2D


@export_enum("blue", "cyan", "green", "magenta", "mint", "orange", "purple", "red", "yellow") var character_name: String


@onready var animated_sprite_2d: AnimatedSprite2D = $NpcRotationMarker/AnimatedSprite2D


func _ready() -> void:
	animated_sprite_2d.play(character_name)
