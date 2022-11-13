extends Hand

"""
hand visible inherited class. basically the same thing as Hand except
it shows the cards and animations.
"""
var cardsInstances: Array = []

var enabled: bool = false

onready var path: Path2D = $Path
onready var curve: Curve2D = path.get_curve()

const cardPath: String = "res://entities/cardsystem/Card.tscn"

func _ready() -> void:
	pass

func _process(delta):
	if !cardsInstances.empty():
		for card in cardsInstances:
			if card.isSelected:
				cardSelected = cardsInstances.find(card, 0)
	for card in cardsInstances:
		card.isSelectable = enabled

#instantiate a new Card as a child based on the cardData
func addCard(newCardData: CardData) -> void:
	.addCard(newCardData)
	
	var newCardPackedScene = preload(cardPath)
	var newCard = newCardPackedScene.instance()
	newCard.cardData = newCardData
	
	newCard.position = Vector2.ZERO
	
	
	.call_deferred("add_child", newCard)
	cardsInstances.append(newCard)
	
	update()
	#TODO place the card at the right place on the screen
func _getPointRatio(index:int) -> Array:
	var point_count = curve.get_point_count()-1
	var size = cardsInHand.size()+1
	var point: int = (index+1)*point_count/size
	var ratio: float = ((index+1)*point_count*1.0/size) - point
	return [point, ratio]

func _getCardRotation(index: int) -> float:
	var pointRatio = _getPointRatio(index)
	var point1 = curve.interpolate(pointRatio[0], pointRatio[1])
	var point2 = curve.interpolate(pointRatio[0], pointRatio[1]+0.001)
	print(point2-point1)
	return (point2-point1).angle()/2

func _getCardPosition(index: int) -> Vector2:
	var pointRatio = _getPointRatio(index)
	return curve.interpolate(pointRatio[0], pointRatio[1])+path.position

#places all the cards in the right place.
func _draw() ->void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	
	for i in range(cardsInHand.size()):
		var newPos = _getCardPosition(i)
		tween.tween_property(cardsInstances[i],
			"position",
			newPos,
			0.2)
		var newRot = _getCardRotation(i)
		tween.tween_property(cardsInstances[i],
			"rotation",
			newRot,
			0.2)
	

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
