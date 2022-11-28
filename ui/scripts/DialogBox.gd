extends Control
class_name DialogBox

signal done_writing

var text_queue: Array = ["This is a test line", "This is a second test line"]
var can_proceed: bool = false
var write_rest_of_line: bool = false
var text_place: int = 0

onready var animPlayer: AnimationPlayer = $AnimationPlayer
onready var textBox: RichTextLabel = $Background/RichTextLabel
onready var timer: Timer = $LetterTimer
onready var nextArrow: Label = $Background/NextArrow

func _ready():
	text_place = 0
	connect("done_writing", self, "_on_done_writing")
	enter()
	_print_line(text_queue[0])
	text_place += 1

func _process(delta):
#	print(can_proceed)
	if Input.is_action_just_pressed("select") && !can_proceed:
		write_rest_of_line = true
	if Input.is_action_just_pressed("select") && can_proceed:
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
	nextArrow.visible = false
	for i in line.length():
		can_proceed = false
		if !write_rest_of_line:
			timer.start()
			textBox.append_bbcode(line[i])
			yield(timer, "timeout")
		else:
			textBox.append_bbcode(line.substr(i, line.length()-1))
			break
	nextArrow.visible = true
	write_rest_of_line = false
	can_proceed = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if "exit" in anim_name:
		emit_signal("done_writing")
		queue_free()
