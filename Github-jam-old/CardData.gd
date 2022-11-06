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

var actions: Array = []


#Loads a JSON into all the fields
func loadJSON(cardJSON: String) -> bool:
	return false
