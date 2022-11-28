extends Cutscene

func _ready():
	set_next_scene("res://scenes/Game.tscn")
	set_story_text([
		"So, this is finally it.",
		"It's the day you've been dreading, the day that's been keeping you up at night for weeks.",
		"It's finally time to break up with Ceighsey.",
		"You've gotta pick the right things to say, you can't let them get off the hook easy.",
		"Your reservation is ready. It's now or never..."
	])
	emit_signal("dialog_set")
