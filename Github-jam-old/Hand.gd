extends Node2D

class_name Hand

"""
This is the hand class! each hand has a bunch of cards! 
THIS IS FOR THE LOGIC it will NOT be visible unless you use the 
HandVisible inherited class.
"""

var cardsInHand: Array = []
var cardSelected: int = 0

#instantiate a new Card as a child based on the cardData
func addCard(newCardData: CardData) -> void:
	cardsInHand.push_back(newCardData)

func removeCard(cardIndex: int) -> void:
	cardsInHand.pop_at(cardIndex)

#plays the activation animation based on the card selected
func activateCard(cardIndex: int) -> void:
	removeCard(cardIndex)

#plays the discard animation based on the card selected
func disCard(cardIndex: int) -> void:
	removeCard(cardIndex)

