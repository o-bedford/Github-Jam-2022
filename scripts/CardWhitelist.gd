extends Node

class_name CardWhitelist

#blacklist
var blacklist: bool = false
var allowAll: bool = true
var trapList: bool = false

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
var trapTimeout: int = 0
var actionTimeout: int = 0
var futureTimeout: int = 0
var intimacyTimeout: int = 0
var socialTimeout: int = 0
var growthTimeout: int = 0

var timeouts:Array = [trapTimeout, actionTimeout, futureTimeout, intimacyTimeout, socialTimeout, growthTimeout]

func checkCard(card: CardData) -> bool:
	if blacklist:
		return false
	
	if allowAll:
		return true
	
	if trapList:
		if "trap" in card.type:
			match card.topic:
				"action":
					return actionTimeout > 0
				"future":
					return futureTimeout > 0
				"intimacy":
					return intimacyTimeout > 0
				"social":
					return socialTimeout > 0
				"growth":
					return growthTimeout > 0
				"any":
					return trapTimeout > 0
		return false
	#check if the card has that topic, is in the right SP range, etc.
	if !(topic in card.topic.to_lower()) && !(card.min_SP >= SP):
		return false
	
	#check if the conditions are met
	if canPlayHand:
		if "action" in card.type:
			if !actionTimeout > 0:
				return false
			if "future" in card.topic && futureTimeout > 0:
				return false
			if "intimacy" in card.topic && intimacyTimeout > 0:
				return false
			if "social" in card.topic && socialTimeout > 0:
				return false
			if "growth" in card.topic && growthTimeout > 0:
				return false
		if "trap" in card.type && trapTimeout > 0:
			return false
	return true
