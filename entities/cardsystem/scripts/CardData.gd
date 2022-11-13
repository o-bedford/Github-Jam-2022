extends Node

class_name CardData

"""
This class saves the data for a card. 
Use THIS when putting it into arrays.
"""

var id: int = 1

var topic: int = Global.TOPICS.MONEY 

var SP: int = 1

var quip: String = "Test Quip"

var description: String = "Test Description. This is a long one."

var actions_str: String
var actions: Array = []

var status_effect: String = "Probably don't want this to be a string"

##Loads a JSON into all the fields
#func loadJSON(cardJSON: String) -> bool:
#	return false

func deepCopy(otherCardData: CardData) -> void:
	id = otherCardData.id
	topic = otherCardData.topic
	SP = otherCardData.SP
	quip = otherCardData.quip
	description = otherCardData.description
	actions = otherCardData.actions
	status_effect = otherCardData.status_effect

func loadDataFromDB(data: Dictionary) -> bool:
	id = data["ID"]
#	topic = data["Topic"]
	SP = data["SP"]
	quip = data["Blurb"] # Or dialogue. Not sure
	if data["Dialogue"] != null:
		description = data["Dialogue"]
	# Splits the action string up into a usable action array
	if data["Action"] != null:
		actions_str = data["Action"]
		actions = actions_str.split(",")
		for i in actions.size():
			actions[i] = actions[i].split(" ")
	if data["Status"] != null:
		status_effect = data["Status"]
	
	return false
