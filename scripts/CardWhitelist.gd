extends Node

class_name CardWhitelist

#blacklist
var blacklist: bool = false
var allowAll: bool = false
var trapList: bool = false

#general game state
var SP: int = 0
var topic: String = "any"
var SP_range: Array = []

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
var topicTimeouts: Array = [futureTimeout, intimacyTimeout, socialTimeout, growthTimeout]

func checkCard(card: CardData) -> bool:
	if blacklist:
		return false
	
	if allowAll:
		return true
	
	if trapList:
#		if "trap" in card.type && (topic in card.topic || "any" in card.topic):
		if "trap" in card.type:
			match card.topic:
				"future":
					return futureTimeout == 0
				"intimacy":
					return intimacyTimeout == 0
				"social":
					return socialTimeout == 0
				"growth":
					return growthTimeout == 0
		return false
	
	#check if the card has that topic, is in the right SP range, etc.
	if !SP_range.empty():
		if !(topic in card.topic.to_lower()) && !(card.SP in range(SP_range[0],SP_range[1])):
			print(str(card.SP) + " " + str(SP_range))
			return false
	else:
		if !(topic in card.topic.to_lower() || "any" in topic):
			print("this is not supposed to happen")
			return false
	
	#check if the conditions are met
	if canPlayHand:
		if "action" in card.type:
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
