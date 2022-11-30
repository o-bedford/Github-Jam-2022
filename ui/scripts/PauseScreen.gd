extends Panel
class_name PauseScreen

var start_pos: Vector2 = Vector2(534, 840)
var button_pause: bool = false
var leaving: bool = false

onready var resume_button = $Button

func _ready():
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
