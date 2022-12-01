extends TextureRect
class_name PauseScreen

var start_pos: Vector2 = Vector2(534, 840)
var button_pause: bool = false
var leaving: bool = false

onready var resume_button = $CenterContainer/VBoxContainer/Button
onready var music_slider = $CenterContainer/VBoxContainer/MusicSlider
onready var sfx_slider = $CenterContainer/VBoxContainer/SFXSlider

func _ready():
	music_slider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Background")))
	sfx_slider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	pause_mode = PAUSE_MODE_PROCESS
	rect_position = start_pos
	var tween: SceneTreeTween
	tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "rect_position", Vector2(534, 277), 0.5)

func _process(_delta):
	if !get_tree().paused && !button_pause && !leaving:
		leaving = true
		var leave_tween: SceneTreeTween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
		leave_tween.tween_property(self, "rect_position", start_pos, 0.5)
		yield(leave_tween, "finished")
		queue_free()

func _on_Button_pressed():
	button_pause = true
	get_tree().paused = false
	var leave_tween: SceneTreeTween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	leave_tween.tween_property(self, "rect_position", start_pos, 0.5)
	yield(leave_tween, "finished")
	queue_free()


func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Background"), linear2db(value))


func _on_SFXSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))
