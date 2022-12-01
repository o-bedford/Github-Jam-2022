extends Node2D

onready var credits: Sprite = $Sprite

func _process(delta):
	credits.position.y -= 0.8


func _on_OyinTwitter_pressed():
	OS.shell_open("https://twitter.com/cdplayerptx")

func _on_OyinGithub_pressed():
	OS.shell_open("https://github.com/o-bedford/")

func _on_JayaLink_pressed():
	OS.shell_open("http://ghostlysleuth.weebly.com/")

func _on_JayaTwitter_pressed():
	OS.shell_open("http://twitter.com/ghostlysleuth")


func _on_KatLink_pressed():
	OS.shell_open("https://kattvngu.carrd.co/")



func _on_AmiikuLink_pressed():
	OS.shell_open("https://instagram.com/amiikuo?igshid=YmMyMTA2M2Y=")




func _on_AlexLink2_pressed():
	OS.shell_open("https://www.youtube.com/c/MxngoLovesYou")


func _on_AlexLink3_pressed():
	OS.shell_open("https://twitter.com/__MXNGO")


func _on_HelpFromLink_pressed():
	OS.shell_open("https://twitter.com/nihilo_games")
