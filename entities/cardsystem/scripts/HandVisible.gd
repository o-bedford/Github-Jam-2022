extends Hand

"""
hand visible inherited class. basically the same thing as Hand except
it shows the cards and animations.
"""

const cardPath: String = "res://entities/cardsystem/Card.tscn"

#instantiate a new Card as a child based on the cardData
func addCard(newCardData: CardData) -> void:
	.super(newCardData)
	
	var newCard = preload(cardPath)
	newCard.cardData = newCardData
	.call_deferred("add_child", newCard)
	
	
	
	#TODO place the card at the right place on the screen

#plays the activation animation based on the card selected
func activateCard(cardIndex: int) -> void:
	#TODO card animation
	removeCard(cardIndex)

#plays the discard animation based on the card selected
func disCard(cardIndex: int) -> void:
	#TODO card animation
	removeCard(cardIndex)

#do whatever animation you need to do if a card is selected
func cardSelected(card: Card) -> void:
	pass
