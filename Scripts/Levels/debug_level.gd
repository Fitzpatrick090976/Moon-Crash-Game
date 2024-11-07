extends Node2D


# DEFAULT DIALOGUE FOR CURRENT LEVEL


func default_dialogue():
	# Return key from character's json with title of level,
	# e.g. "debug_level"
	# Each character has one default for each level they are in
	return "debug_level"
