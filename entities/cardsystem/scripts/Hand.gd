extends Node2D

class_name Hand

"""
This is the hand class! each hand has a bunch of cards! 
THIS IS FOR THE LOGIC it will NOT be visible unless you use the 
HandVisible inherited class.
"""
signal discard_animation_finished

var cardsInHand: Array = []
var cardSelected: int = -1

var drawCard: bool = false
var cardDrawn: bool = false
var isSkip: bool = false

func changeState(whitelist: CardWhitelist) -> void:
	pass

func enableDrawing(enable: bool, is_skip:bool) ->void:
	cardDrawn = false
	drawCard = enable

func perk(amount: int) -> void:
	for i in range(cardsInHand.size()):
		cardsInHand[i].SP = clamp(cardsInHand[i].SP+amount, 0.0, 12.0)

#instantiate a new Card as a child based on the cardData
func addCard(newCardData: CardData) -> void:
	cardsInHand.push_back(newCardData)

func removeCard(cardIndex: int) -> CardData:
	return cardsInHand.pop_at(cardIndex)

#plays the activation animation based on the card selected
func activateCard() -> CardData:
	var cardDiscarded = disCard(cardSelected)
	cardSelected = -1
#	print(cardDiscarded)
	return cardDiscarded

#plays the discard animation based on the card selected
func disCard(cardIndex: int) -> CardData:
	cardSelected = -1
	return removeCard(cardIndex)

func justDiscard(cardIndex:int) -> CardData:
	return disCard(cardIndex)

func size() -> int:
	return cardsInHand.size()

func getSelectedCard() -> CardData:
	if cardSelected == -1:
		return null
	return cardsInHand[cardSelected]
