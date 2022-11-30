extends Control
var time_start = 0
var time_now = 0
var button = Button.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():


	button.text = "CLICK HERE TO START THE GAME!"

	button.connect("pressed", self, "_button_pressed")
	add_child(button)

	button.rect_size.x = 100
	button.rect_size.y = button.rect_size.x
	button.rect_position.x = (get_viewport_rect().size[0] - button.rect_size.x) / 2 
	button.rect_position.y = (get_viewport_rect().size[1] - button.rect_size.y) / 2
	get_tree().get_root().connect("size_changed", self, "resizeWindow")


func resizeWindow():
	button.rect_size.x = 100
	button.rect_size.y = button.rect_size.x
	button.rect_position.x = (get_viewport_rect().size[0] - button.rect_size.x) / 2 
	button.rect_position.y = (get_viewport_rect().size[1] - button.rect_size.y) / 2

func _button_pressed():
	get_tree().change_scene("res://scenes/PreGameStory.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
