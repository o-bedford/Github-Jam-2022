extends Control
class_name DialogBox

signal done_writing

var text_queue: Array = ["This is a test line", "This is a second test line"]
var can_proceed: bool = false
var write_rest_of_line: bool = false
var text_place: int = 0

onready var animPlayer: AnimationPlayer = $AnimationPlayer
onready var textBox: RichTextLabel = $VBoxContainer/Background/RichTextLabel
onready var timer: Timer = $LetterTimer

func _ready():
	connect("done_writing", self, "_on_done_writing")
	enter()
	_print_line(text_queue[0])
	text_place += 1

func _process(delta):
#	print(can_proceed)
	if Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_accept") && !can_proceed:
		write_rest_of_line = true
	if Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_accept") && can_proceed:
		if text_place < text_queue.size():
			textBox.clear()
			_print_line(text_queue[text_place])
			text_place += 1
		else:
			exit()

func enter() -> void:
	animPlayer.play("enter")

func exit() -> void:
	animPlayer.play("exit")

func _print_line(line: String) -> void:
	for i in line.length():
		can_proceed = false
		if !write_rest_of_line:
			timer.start()
			textBox.add_text(line[i])
			yield(timer, "timeout")
		else:
			textBox.add_text(line.substr(i, line.length()-1))
			break
	write_rest_of_line = false
	can_proceed = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if "exit" in anim_name:
		emit_signal("done_writing")
		queue_free()
