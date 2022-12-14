extends Node2D

class_name Card

"""
This Card class will be used when we want to show a card on screen.
THIS IS NOT the class that will store the data. Refer to the CardData class instead.
"""

onready var cardData: CardData = $CardData

onready var spLabel: Label = $Background/VBoxContainer/HBoxContainer/SPLabel
onready var topicIcon: TextureRect = $Background/VBoxContainer/HBoxContainer/TopicIcon

onready var illustration: TextureRect = $Background/VBoxContainer/Illustration

onready var quipLabel: Label = $Background/VBoxContainer/QuipLabel
onready var descriptionLabel: Label = $Background/VBoxContainer/DescriptionLabel


func _ready():
	pass

#Goes through each CardData element and changes the children of Card based on the Data
#call update() whenever something changes.
func _draw():
	
	spLabel.text = str(cardData.SP)
	
	topicIcon.texture = load("res://icon.png") #TODO add pictures lmao
	
	illustration.texture = load("res://icon.png") #TODO add pictures
	
	quipLabel.text = cardData.quip
	
	descriptionLabel.text = cardData.description

#used for emitting signals, when the mouse hovers over the card
func _on_Background_mouse_entered() -> void:
	pass # Replace with function body.

#used for emitting signals, when the mouse stops hovering over the card
func _on_Background_mouse_exited() -> void:
	pass # Replace with function body.

#used for emitting signals, tell the game to resolve the card actions
func _on_Background_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
