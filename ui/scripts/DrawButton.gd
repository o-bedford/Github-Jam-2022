extends Button


onready var texture = $TextureRect.texture

func _on_DrawButton_pressed() -> void:
	print("pressed")
