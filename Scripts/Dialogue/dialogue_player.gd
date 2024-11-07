extends CanvasLayer


func _ready() -> void:
	SignalBus.show_dialogue.connect(_on_show_dialogue)
	# Request from current scene "what is my default dialogue?"
	print(get_tree().current_scene.default_dialogue())


func _on_show_dialogue(key):
	# Where "key" is specific interaction
	# Dialogue will loop until choice is made
	var dialogue = JsonManager.data[key][0]
	print(dialogue)
