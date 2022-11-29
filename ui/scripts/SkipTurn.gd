extends Label

signal skip_turn_fade_in
signal skip_turn_fade_out

func _ready() -> void:
	add_color_override("font_color", Color(1, 75/255, 75/255, 0))

func fade_in() -> void:
	emit_signal("skip_turn_fade_in")

func fade_out() -> void:
	emit_signal("skip_turn_fade_out")
