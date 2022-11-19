extends Hand

"""
hand visible inherited class. basically the same thing as Hand except
it shows the cards and animations.
"""
var cardsInstances: Array = []

var enabled: bool = false
var cardHoveredIndex: int = -1
var bufferCard: int = 2 #how many invisible cards the hovered card will have around it
onready var path: Path2D = $Path
onready var curve: Curve2D = path.get_curve()
onready var cardHoverHeight: float = $CardHoverHeight.position.y
onready var cardActivatePos: Vector2 = $CardActivate.position
onready var deckPos: Vector2 = $DeckPosition.position
onready var graveyardPos: Vector2 = $GraveyardPosition.position

const cardPath: String = "res://entities/cardsystem/Card.tscn"

func _ready() -> void:
	pass

func _process(delta):
	if !cardsInstances.empty():
		for card in cardsInstances:
			card.isSelectable = enabled
			if card.isSelected:
				cardSelected = cardsInstances.find(card, 0)

#instantiate a new Card as a child based on the cardData
func addCard(newCardData: CardData) -> void:
	.addCard(newCardData)
	
	var newCardPackedScene = preload(cardPath)
	var newCard = newCardPackedScene.instance()
	newCard.cardData = newCardData
	
	newCard.position = deckPos
	
	newCard.connect("card_hovered", self, "_onCardHovered", [cardsInHand.size()-1])
	newCard.connect("card_unhovered", self, "_onCardUnhovered", [cardsInHand.size()-1])
	
	.call_deferred("add_child", newCard)
	cardsInstances.append(newCard)
	
	update()

func _onCardHovered(index: int) -> void:
	cardHoveredIndex = index
	update()
	pass

func _onCardUnhovered(index: int) -> void:
	cardHoveredIndex = -1
	update()
	pass

func _getPointRatio(index:int, relative: int = 0) -> Array:
	var point_count = curve.get_point_count()-1
	var size = cardsInHand.size()+1
	match relative:
		-1:
			size += bufferCard
		1:
			size += bufferCard
			index += bufferCard
	
	var point: int = (index+1)*point_count/size
	var ratio: float = ((index+1)*point_count*1.0/size) - point
	return [point, ratio]

func _getCardRotation(index: int, relative: int = 0) -> float:
	var pointRatio = _getPointRatio(index, relative)
	var point1 = curve.interpolate(pointRatio[0], pointRatio[1])
	var point2 = curve.interpolate(pointRatio[0], pointRatio[1]+0.001)
	return (point2-point1).angle()/2

func _getCardPosition(index: int, relative: int = 0) -> Vector2:
	var pointRatio = _getPointRatio(index, relative)
	if index != cardHoveredIndex:
		return curve.interpolate(pointRatio[0], pointRatio[1])+path.position
	else:
		var newPose = curve.interpolate(pointRatio[0], pointRatio[1])+path.position
		newPose.y = cardHoverHeight
		return newPose

#places all the cards in the right place.
func _draw() ->void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(true)

	for i in range(cardsInHand.size()):
		var relative = 0
		if cardHoveredIndex != -1:
			if i < cardHoveredIndex:
				relative = -1
			elif i > cardHoveredIndex:
				relative = 1
		
		var newPos = _getCardPosition(i, relative)
		tween.tween_property(cardsInstances[i],
			"position",
			newPos,
			0.2)
			
		var newRot = _getCardRotation(i, relative)
		if i == cardHoveredIndex:
			newRot = 0.0
		tween.tween_property(cardsInstances[i],
			"rotation",
			newRot,
			0.2)

#plays the activation animation based on the card selected
func activateCard() -> CardData:
	_cardActivationAnimation(cardsInstances[cardSelected])
	return .activateCard()

func _cardActivationAnimation(cardInstance: Card) -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(cardInstance, "position", cardActivatePos, 0.2)
	tween.tween_property(cardInstance, "position", cardActivatePos, 1.3)
	yield(tween, "finished")
	_cardDiscardAnimation(cardInstance)

func _cardDiscardAnimation(cardInstance: Card) -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(cardInstance, "position", graveyardPos, 0.2)
	yield(tween, "finished")
	cardInstance.queue_free()

#plays the discard animation based on the card selected
func disCard(cardIndex: int) -> CardData:
	update()
	cardsInstances.pop_at(cardIndex)
	return .disCard(cardIndex)
	

#do whatever animation you need to do if a card is selected
func cardSelected(card: Card) -> void:
	pass
