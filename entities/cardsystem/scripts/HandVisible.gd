extends Hand

"""
hand visible inherited class. basically the same thing as Hand except
it shows the cards and animations.
"""

onready var path: Path2D = $Path
#onready var curve: Curve2D = path.get_curve()
var curve:Curve2D

const cardPath: String = "res://entities/cardsystem/Card.tscn"

func _ready() -> void:
	print(path)
	curve = path.get_curve()
	#print(curve.get_baked_points())
	pass

#instantiate a new Card as a child based on the cardData
func addCard(newCardData: CardData) -> void:
	.addCard(newCardData)
	
	var newCardPackedScene = preload(cardPath)
	var newCard = newCardPackedScene.instance()
	newCard.cardData = newCardData
	
	newCard.position = curve.interpolate(cardsInHand.size()-1,0.0)
	
	
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
