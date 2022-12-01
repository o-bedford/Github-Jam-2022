extends Control
class_name MessageBox

var heading: String = ""
var body_text: String = ""
var initial_enter: bool = true
var enter_finished: bool = false
var exit_finished: bool = false

onready var panel = $NinePatchRect
onready var headingLabel = $NinePatchRect/PhaseLabel
onready var bodyLabel = $NinePatchRect/BodyText
onready var timer = $InitialStay

func _ready():
	initial_enter = true
	set_message("test 1", "test 2")
	enter_screen()

func _draw():
	headingLabel.text = heading
	bodyLabel.text = body_text
	timer.start()

func popup(_heading: String, _body_text: String) -> void:
	set_message(_heading, _body_text)
	enter_screen()

func set_message(_heading: String, _body_text: String) -> void:
	heading = _heading
	body_text = _body_text
	update()

func enter_screen() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(panel, "rect_position", Vector2(0, 8), 0.7)
	yield(tween, "finished")
	enter_finished = true

func exit_screen() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	tween.tween_property(panel, "rect_position", Vector2(0, -256), 0.4)
	yield(tween, "finished")
	exit_finished = true

func _on_InitialStay_timeout():
	exit_screen()
	initial_enter = false

func _on_TextureRect_mouse_entered():
	if !initial_enter && exit_finished:
		print("enter")
		enter_screen()
		exit_finished = false

func _on_TextureRect_mouse_exited():
	print(enter_finished)
	if !initial_enter && enter_finished:
		print("exit")
		exit_screen()
		enter_finished = false
