extends Control
class_name MessageBox

var heading: String = ""
var body_text: String = ""
var initial_enter: bool = true
var entered: bool = false

onready var panel = $Panel
onready var headingLabel = $Panel/PhaseLabel
onready var bodyLabel = $Panel/BodyText
onready var timer = $InitialStay

func _ready():
	initial_enter = true
	set_message("test 1", "test 2")

func _draw():
	headingLabel.text = heading
	bodyLabel.text = body_text
	timer.start()

func set_message(_heading: String, _body_text: String) -> void:
	heading = _heading
	body_text = _body_text
	update()
	enter_screen()

func enter_screen() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(panel, "rect_position", Vector2(0, 168), 0.7)

func exit_screen() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	tween.tween_property(panel, "rect_position", Vector2(0, 0), 0.4)

func _on_InitialStay_timeout():
	exit_screen()
	initial_enter = false

func _on_TextureRect_mouse_entered():
	if !initial_enter:
		print("enter")
		enter_screen()

func _on_TextureRect_mouse_exited():
	if !initial_enter:
		print("exit")
		exit_screen()
