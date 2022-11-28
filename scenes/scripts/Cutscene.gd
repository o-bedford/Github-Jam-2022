extends Control
class_name Cutscene

signal dialog_set

var can_proceed: bool = false
var write_rest_of_line: bool = false
var text_place: int = 0
var story_text: Array = [
	"So, this is finally it.",
	"It's the day you've been dreading, the day that's been keeping you up at night for weeks.",
	"It's finally time to break up with Ceighsey.",
	"You've gotta pick the right things to say, you can't let them get off the hook easy.",
	"Your reservation is ready. It's now or never..."
]
var next_scene_path: String = ""

onready var nextArrow: Label = $NextArrow
onready var timer: Timer = $Timer
onready var textBox = $Dialogue

func _ready() -> void:
	connect("dialog_set", self, "_start_print")
#	_print_line(story_text[0])
#	text_place += 1

func _process(delta):
	if Input.is_action_just_pressed("select") && !can_proceed:
		write_rest_of_line = true
	if Input.is_action_just_pressed("select") && can_proceed:
		if text_place < story_text.size():
			textBox.text = ""
			_print_line(story_text[text_place])
			text_place += 1
		else:
			get_tree().change_scene(next_scene_path)

func set_story_text(text: Array) -> void:
	story_text = text

func set_next_scene(scene: String) -> void:
	next_scene_path = scene

func _print_line(line: String) -> void:
	nextArrow.visible = false
	for i in line.length():
		can_proceed = false
		if !write_rest_of_line:
			timer.start()
			textBox.text += line[i]
			yield(timer, "timeout")
		else:
			textBox.text += (line.substr(i, line.length()-1))
			break
	nextArrow.visible = true
	write_rest_of_line = false
	can_proceed = true

func _start_print() -> void:
	_print_line(story_text[0])
	text_place += 1
