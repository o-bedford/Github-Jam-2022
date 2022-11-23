extends Node

class_name CardWhitelist

#blacklist
var blacklist: bool = false

#general game state
var SP: int = 0
var topic: String = ""

#different conditions
var canPlayHand: bool = true
#var canPlayTransition: bool = true
#var canPlayTrap: bool = true
#var canPlayAction: bool = true
#var canPlayFuture: bool = true
#var canPlayIntimacy: bool = true
#var canPlaySocial: bool = true
#var canPlayHobbies: bool = true
#var canPlayHouse: bool = true
#var canPlayAny: bool = true

# Timeout in turns
var transitionTimeout: int = 0
var trapTimeout: int = 0
var actionTimeout: int = 0
var futureTimeout: int = 0
var intimacyTimeout: int = 0
var socialTimeout: int = 0
var hobbiesTimeout: int = 0
var houseTimeout: int = 0

var timeouts:Array = [transitionTimeout, trapTimeout, actionTimeout, futureTimeout, intimacyTimeout, socialTimeout, hobbiesTimeout, houseTimeout]

func checkCard(card: CardData) -> bool:
	if blacklist:
		return false

	#check if the card has that topic, is in the right SP range, etc.
	if !(topic in card.topic.to_lower()) && !(card.min_SP >= SP):
		return false
	
	#check if the conditions are met
	if canPlayHand:
		if "action" in card.type && actionTimeout > 0:
			return false
		if "transition" in card.type:
			if "future" in card.topic && futureTimeout > 0:
				return false
			if "intimacy" in card.topic && intimacyTimeout > 0:
				return false
			if "social" in card.topic && socialTimeout > 0:
				return false
			if "hobbies" in card.topic && hobbiesTimeout > 0:
				return false
			if "house" in card.topic && houseTimeout > 0:
				return false
			if !transitionTimeout > 0:
				return false
		if "trap" in card.type && trapTimeout > 0:
			return false
	return true
