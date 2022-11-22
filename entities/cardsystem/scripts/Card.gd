extends Node2D

class_name Card

"""
This Card class will be used when we want to show a card on screen.
THIS IS NOT the class that will store the data. Refer to the CardData class instead.
"""

signal card_hovered(index)
signal card_unhovered(index)
signal card_selected(index)

var cardData: CardData = null
var isSelected: bool = false
var isSelectable: bool = false

onready var spLabel: Label = $Background/VBoxContainer/HBoxContainer/SPLabel
onready var topicIcon: TextureRect = $Background/VBoxContainer/HBoxContainer/TopicIcon

onready var illustration: TextureRect = $Background/VBoxContainer/Illustration

onready var quipLabel: Label = $Background/VBoxContainer/QuipLabel
onready var descriptionLabel: Label = $Background/VBoxContainer/DescriptionLabel


func _ready():
	pass

#func load_new_data(newCardData: CardData) -> void:
#	cardData = newCardData
#	update()

#Goes through each CardData element and changes the children of Card based on the Data
#call update() whenever something changes.
func _draw():
	if cardData:
		spLabel.text = str(cardData.SP)

		topicIcon.texture = load("res://icon.png") #TODO add pictures lmao
		
		illustration.texture = load("res://icon.png") #TODO add pictures
		
		quipLabel.text = cardData.quip
		
		descriptionLabel.text = cardData.description

#used for emitting signals, when the mouse hovers over the card
func _on_SelectBox_mouse_entered() -> void:
	if !isSelected:
		emit_signal("card_hovered")
		z_index = 1

#used for emitting signals, when the mouse stops hovering over the card
func _on_SelectBox_mouse_exited() -> void:
	if !isSelected:
		emit_signal("card_unhovered")
		z_index = 0

#used for emitting signals, tell the game to resolve the card actions
func _on_SelectBox_gui_input(event: InputEvent) -> void:
	if isSelectable:
		if Input.is_action_just_pressed("select"):
			isSelected = true
			emit_signal("card_selected")
