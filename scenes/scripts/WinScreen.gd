extends Control

var win_theme: String = "res://sounds/bg/OST 7 - YOU BEAT THEIR ASS!.ogg"

func _ready() -> void:
	BgMusic.fade_in(win_theme, 1.0)
