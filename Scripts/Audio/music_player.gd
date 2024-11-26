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


func _on_level_start(curr_level: String):
	stream = load(music_dict[curr_level])


var music_dict = {
	"day_one": "res://Audio/Music/DayOne.wav",
	"day_two": "res://Audio/Music/DayTwo.wav",
	"day_three": "res://Audio/Music/DayThree.wav",
	"moon_encounter": "res://Audio/Music/MoonEncounter.wav",
}
