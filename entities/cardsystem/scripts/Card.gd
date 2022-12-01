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

onready var spLabel: RichTextLabel = $Background/VBoxContainer/HBoxContainer/SPLabel
onready var topicIcon: TextureRect = $Background/VBoxContainer/HBoxContainer/TopicIcon

onready var illustration: TextureRect = $Background/VBoxContainer/Illustration

onready var quipLabel: Label = $Background/VBoxContainer/QuipLabel
onready var descriptionLabel: Label = $Background/VBoxContainer/DescriptionLabel

onready var glow: Sprite = $Glow


func _ready():
	glow.visible = false

#func load_new_data(newCardData: CardData) -> void:
#	cardData = newCardData
#	update()

func _process(delta: float) -> void:
	if isSelectable:
		glow.visible = true
	else:
		glow.visible = false

#Goes through each CardData element and changes the children of Card based on the Data
#call update() whenever something changes.
func _draw():
	if cardData:
		spLabel.text = str(abs(cardData.SP))
		if cardData.SP < 0:
			spLabel.add_color_override("font_color", Color(1,0,0))
			update()
		else:
			spLabel.add_color_override("font_color", Color(0,0,0))
			update()
		
		topicIcon.texture = load("res://icon.png") #TODO add pictures lmao
		
		illustration.texture = load("res://icon.png") #TODO add pictures
		
		quipLabel.text = cardData.quip
		
		descriptionLabel.text = _getDescription()

func _getDescription() -> String:
	
	var description: String = ""
	
	if cardData.type == "action":
		for action in cardData.actions:
			match action[0]:
				"SP":
					pass
				"topic":
					if action[1] != cardData.topic:
						description += "[b]Change topic[/b] to " + action[1] + "\n"
				"spClear":
					description += "Cards of [b]any SP[/b] can be played on top of this card\n"
				"topicEnder":
					description += "[b]Any[/b] topic can be played on top of this card\n"
				"selfPerk":
					description += "Cards in the player's hand[b]"
					if int(action[1]) > 0:
						description += " increase "
					else:
						description += " decrease "
					description += " by " + str(abs(int(action[1]))) + "[/b]\n"
				"oppPerk":
					description += "Cards in the opponent's hand[b]"
					if int(action[1]) > 0:
						description += " increase "
					else:
						description += " decrease "
					description += " by " + str(abs(int(action[1]))) + "[/b]\n"
				"ceil":
					description += "Cards cannot [b]escalate[\b]\n"
				"floor":
					description += "Cards cannot [b]deescalate[\b]\n"
	elif cardData.type == "trap":
		for condition in cardData.conditions:
			match condition[0]:
				"escalate":
					description += "Only play after a card [b]escalates[/b]\n"
				"deescalate":
					description += "Only play after a card [b]deescalates[/b]\n"
				"perk":
					description += "Only play after a [b]perk[/b] card\n"
				"topic":
					description += "Only play after a [b]" + condition[1] + "[/b] or [b]" +condition[2] + "[/b] card\n"
		for action in cardData.actions:
			match action[0]:
				"spClear":
					description += "[b]Any SP[/b] can be played on this card\n"
				"topicEnder":
					description += "[b]Any topic[/b] can be played on this card\n"
				"selfPerk":
					description += "Cards in the opponent's hand will [b]"
					if int(action[1]) > 0:
						description += " increase "
					else:
						description += " decrease "
					description += " by " + str(abs(int(action[1]))) + "[/b]\n"
				"oppPerk":
					description += "Cards in the player's hand will [b]"
					if int(action[1]) > 0:
						description += " increase "
					else:
						description += " decrease "
					description += " by " + str(abs(int(action[1]))) + "[/b]\n"
				"changePerkTarget":
					description += "Change the target of a [b]perk[/b] card\n"
				"changeTarget":
					description += "The SP attack will be returned to its owner\n"
				"changeAttack":
					description += "The SP attack will [b]"
					if int(action[1]) > 0:
						description += " increase "
					else:
						description += " decrease "
					description += " by " + action[1] + "[/b]\n"
	
	return description

#used for emitting signals, when the mouse hovers over the card
func _on_SelectBox_mouse_entered() -> void:
	if !isSelected:
		emit_signal("card_hovered")

#used for emitting signals, when the mouse stops hovering over the card
func _on_SelectBox_mouse_exited() -> void:
	if !isSelected:
		emit_signal("card_unhovered")

#used for emitting signals, tell the game to resolve the card actions
func _on_SelectBox_gui_input(event: InputEvent) -> void:
	if isSelectable:
		if Input.is_action_just_pressed("select"):
			isSelected = true
			emit_signal("card_selected")
