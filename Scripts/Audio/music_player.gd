extends AudioStreamPlayer


# ON LEVEL START
	# LOOK UP PATH TO CORRECT SONG IN DICT
	# LOAD SONG
	# PLAY FADE IN ANIMATION

# ON LEVEL END
	# PLAY FADE OUT ANIMATION


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	SignalBus.level_start.connect(_on_level_start)
	SignalBus.level_end.connect(_on_level_end)


func _on_level_start(curr_level: String):
	stream = load(music_dict[curr_level])
	play()
	animation_player.play("fade_in")


func _on_level_end():
	animation_player.play("fade_out")


var music_dict = {
	"day_one": "res://Audio/Music/DayOne.wav",
	"day_two": "res://Audio/Music/DayTwo.wav",
	"day_three": "res://Audio/Music/DayThree.wav",
	"moon_encounter": "res://Audio/Music/MoonEncounter.wav",
}

func _on_finished() -> void:
	stream_paused = false
	play()
