extends Cutscene

func _ready():
	set_next_scene("res://scenes/WinScreen.tscn")
	set_story_text([
		"That was...",
		"Intense.",
		"You stand up, pushing your seat away.",
		"You spoke your mind, and accomplished what you sought to.",
		"And the last thing you told them was...",
		"It's not me,",
		"It's you."
	])
	emit_signal("dialog_set")
