extends Node2D

const intro_cutscene_path = "res://scenes/PreGameStory.tscn"
const credits_path = "res://scenes/Credits.tscn"

var time_start = 0
var time_now = 0
var button = Button.new()
var music: String = "res://sounds/bg/OST 3 - Rose Wine.ogg"


func _ready():
	BgMusic.set_sound(music)

#	button.text = "CLICK HERE TO START THE GAME!"
#
#	button.connect("pressed", self, "_button_pressed")
#	add_child(button)
#
#	button.rect_size.x = 100
#	button.rect_size.y = button.rect_size.x
#	button.rect_position.x = (get_viewport_rect().size[0] - button.rect_size.x) / 2 
#	button.rect_position.y = (get_viewport_rect().size[1] - button.rect_size.y) / 2
#	get_tree().get_root().connect("size_changed", self, "resizeWindow")


#func resizeWindow():
#	button.rect_size.x = 100
#	button.rect_size.y = button.rect_size.x
#	button.rect_position.x = (get_viewport_rect().size[0] - button.rect_size.x) / 2 
##	button.rect_position.y = (get_viewport_rect().size[1] - button.rect_size.y) / 2
#
#func _button_pressed():
#	var intro_cutscene = preload(intro_cutscene_path)
#	BgMusic.fade_out(3.0)
#	FancyFade.tile_reveal(intro_cutscene.instance(), 2.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Credits_pressed():
	var credits = preload(credits_path)
	FancyFade.tile_reveal(credits.instance(), 0.8)


func _on_Start_pressed():
	var intro_cutscene = preload(intro_cutscene_path)
	BgMusic.fade_out(3.0)
	FancyFade.tile_reveal(intro_cutscene.instance(), 2.0)
