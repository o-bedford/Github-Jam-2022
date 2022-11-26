extends Hand

"""
hand visible inherited class. basically the same thing as Hand except
it shows the cards and animations.
"""

var cardsInstances: Array = []

var cardInstanceSelected: Card

var enabled: bool = true
var cardHoveredIndex: int = -1
var bufferCard: int = 2 #how many invisible cards the hovered card will have around it
onready var path: Path2D = $HandArea/Path
onready var curve: Curve2D = path.get_curve()
onready var cardHoverHeight: float = $CardHoverHeight.position.y
onready var cardActivatePos: Vector2 = $CardActivate.position
onready var deckPos: Vector2 = $DeckPosition.position
onready var graveyardPos: Vector2 = $GraveyardPosition.position

onready var handArea: Node2D = $HandArea
onready var handAreaRect: CollisionShape2D = $HandArea/HoverArea/CollisionShape2D
onready var handAreaPos: Vector2 = $HandArea.position

onready var drawButton: Button = $DrawButton

const cardPath: String = "res://entities/cardsystem/Card.tscn"

func _ready() -> void:
	pass

func changeState(whitelist: CardWhitelist) -> void:
	var canPlay = false
	for i in range(cardsInHand.size()):
		if whitelist.checkCard(cardsInHand[i]):
			canPlay = true
			cardsInstances[i].isSelectable = true
			cardsInstances[i].set_modulate(Color(1,1,1,1))
		else:
			cardsInstances[i].isSelectable = false
			cardsInstances[i].set_modulate(Color(0.5,0.5,0.5,1))
	
	if !canPlay and drawCard:
		cardDrawn = true
		emit_signal("draw_card")

func enableDrawing(enable: bool) ->void:
	.enableDrawing(enable)
	
	if enable:
		drawButton.modulate = Color(1, 1, 1, 1)
		drawButton.disabled = false
	else:
		drawButton.modulate = Color(1, 1, 1, 0.5)
		drawButton.disabled = true

#instantiate a new Card as a child based on the cardData
func addCard(newCardData: CardData) -> void:
	.addCard(newCardData)
	
	var newCardPackedScene = preload(cardPath)
	var newCard = newCardPackedScene.instance()
	newCard.cardData = newCardData
	
	newCard.position = deckPos
	
	newCard.connect("card_hovered", self, "_onCardHovered", [newCard])
	newCard.connect("card_unhovered", self, "_onCardUnhovered", [newCard])
	newCard.connect("card_selected", self, "_onCardSelected", [newCard])
	
	.call_deferred("add_child", newCard)
	cardsInstances.append(newCard)
	
	update()

func _onCardHovered(cardNum: Card) -> void:
	cardHoveredIndex = cardsInstances.find(cardNum, 0)
	cardNum.z_index = 1
	update()
	pass

func _onCardUnhovered(cardNum: Card) -> void:
	cardHoveredIndex = -1
	cardNum.z_index = 0
	update()
	pass


func _onCardSelected(cardNum: Card) -> void:
	cardSelected = cardsInstances.find(cardNum, 0)
	cardInstanceSelected = cardNum


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
		return curve.interpolate(pointRatio[0], pointRatio[1])+path.position+handArea.position
	else:
		var newPose = curve.interpolate(pointRatio[0], pointRatio[1])+path.position
		newPose.y = cardHoverHeight
		return newPose+handArea.position

#places all the cards in the right place.
func _draw() ->void:
	
	#for i in range(cardsInHand.size()):
	#	print(cardsInstances[i].quipLabel.text, cardsInHand[i].quip)
	
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
	_cardActivationAnimation(cardInstanceSelected)
	return .activateCard()

func _cardActivationAnimation(cardInstance: Card) -> void:
	cardInstance.set_modulate(Color(1,1,1,1))
	cardInstance.z_index = 2
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
	emit_signal("discard_animation_finished")

#plays the discard animation based on the card selected
func disCard(cardIndex: int) -> CardData:
	update()
	cardsInstances.pop_at(cardIndex)
	return .disCard(cardIndex)
	

#do whatever animation you need to do if a card is selected
func cardSelected(card: Card) -> void:
	pass


func _on_HoverArea_mouse_entered() -> void:
	handArea.position = Vector2.ZERO
	update()


func _on_HoverArea_mouse_exited() -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var rect: Rect2 = Rect2(handAreaRect.position, handAreaRect.shape.extents)
	if rect.has_point(mouse_position):
		return
	handArea.position = handAreaPos
	update()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if drawCard and Input.is_action_pressed("ui_accept"):
			emit_signal("draw_card")
			cardDrawn = true
func _on_DrawButton_pressed() -> void:
	emit_signal("draw_card")
	cardDrawn = true
