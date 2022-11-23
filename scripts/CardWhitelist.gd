extends Node

class_name CardWhitelist

#blacklist
var blacklist: bool = false

#general game state
var SP: int = 0
var topic: String = ""

#different conditions
var canPlayHand: bool = true
var canPlayTransition: bool = true
var canPlayTrap: bool = true
var canPlayAction: bool = true
var canPlayFuture: bool = true
var canPlayIntimacy: bool = true
var canPlaySocial: bool = true
var canPlayHobbies: bool = true
var canPlayHouse: bool = true

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
		if "transition" in card.type && canPlayTransition && transitionTimeout == 0:
			return true
		if "trap" in card.type && canPlayTrap && trapTimeout == 0:
			return true
		if "action" in card.type && canPlayAction && actionTimeout == 0:
			return true
		if "future" in card.topic && canPlayFuture && futureTimeout == 0:
			return true
		if "intimacy" in card.topic && canPlayIntimacy && intimacyTimeout == 0:
			return true
		if "social" in card.topic && canPlaySocial && socialTimeout == 0:
			return true
		if "hobbies" in card.topic && canPlayHobbies && hobbiesTimeout == 0:
			return true
		if "house" in card.topic && canPlayHouse && houseTimeout == 0:
			return true
	return false
