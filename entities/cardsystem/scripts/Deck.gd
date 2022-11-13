extends Node2D

class_name Deck

"""
This is the deck. It can be shuffled. it also has a graveyard
"""

var deck: Array = []
var graveyard: Array = []

#shuffle the deck
func shuffleDeck() -> void:
	deck.shuffle()

#shuffle the graveyard
func shuffleGraveyard() -> void:
	pass

#draws one from the top of the deck
func drawCard() -> CardData:
	return deck.pop_front()
