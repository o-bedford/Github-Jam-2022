extends Node

const pause_screen_path = "res://ui/PauseScreen.tscn"
var paused: bool = false
onready var pause_screen = preload(pause_screen_path)

func _ready():
	pause_mode = PAUSE_MODE_PROCESS

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		paused = true if !paused else false
		if paused:
			var pause_screen_inst = pause_screen.instance()
			add_child(pause_screen_inst)
		get_tree().paused = paused
