extends Node

class_name CardWhitelist

#blacklist
var blacklist: bool = false

#general game state
var SP: int = 0
var topic: String = ""

#different conditions
var canPlayTransition: bool = true

func checkCard(card: CardData) -> bool:
	if blacklist:
		return false

	#check if the card has that topic, is in the right SP range, etc.
	
	#check if the conditions are met
	
	return true
