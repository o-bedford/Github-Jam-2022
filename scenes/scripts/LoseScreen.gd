extends Control

var lose_theme: String = "res://sounds/bg/OST 6 - Date Failed.ogg"

func _ready() -> void:
	BgMusic.fade_in(lose_theme, 1.0)
