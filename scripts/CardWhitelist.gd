extends Node

class_name CardWhitelist

#blacklist
var blacklist: bool = false
var allowAll: bool = false
var trapList: bool = false

#general game state
var SP: int = 0
var topic: String = "any"
var SP_range: Array = [0,5]

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
		if "trap" in card.type:
			if !card.conditions.empty():
				for condition in card.conditions:
					if "escalate" in condition[0]:
						if !Global.escalate:
							return false
					if "perk" in condition[0]:
						if !Global.perk:
							return false
					if "topic" in condition[0]:
						if !((condition[1] in topic) or (condition[2] in topic)):
							return false
			return true
		return false
	else:
		if "trap" in card.type:
			return false
	#check if the card has that topic, is in the right SP range, etc.
	if !SP_range.empty():
		if !("any" in topic):
			if !(topic in card.topic.to_lower()):
				return false
		
		if !(card.SP in range(SP_range[0],SP_range[1]+1)):
			return false
	else:
		if !(topic in card.topic.to_lower() || "any" in topic):
			print("this is not supposed to happen", card.topic)
			return false
	

	return true
