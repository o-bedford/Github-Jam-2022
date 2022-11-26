extends Hand

"""
hand visible inherited class. basically the same thing as Hand except
the AI gets to choose their cards
"""
var cardCanSelect: Array = []
var card : CardData

const cardPath: String = "res://entities/cardsystem/Card.tscn"

onready var cardPos: Vector2 = $CardPos.position
onready var discardPos: Vector2 = $DiscardPos.position

func changeState(whitelist: CardWhitelist) -> void:
	cardCanSelect = []
	for i in range(cardsInHand.size()):
		cardCanSelect.append(whitelist.checkCard(cardsInHand[i]) )
	call_deferred("chooseCard")

### THIS IS THE AI LOGIC IT HAS TO CHOOSE BETWEEN SELECTABLE CARDS
func chooseCard() -> void:
	var desirable_card: int = -1
	var previous_card: CardData = CardData.new()
	
	var previous_weight = -1.0
	for i in range(cardsInHand.size()):
		if cardCanSelect[i]: 
			if cardsInHand[i].weight > previous_weight:
				desirable_card = i
				previous_weight = cardsInHand[i].weight
	
	
	cardSelected = desirable_card
	if desirable_card == -1:
		if drawCard:
			cardDrawn = true
	else:
		card = cardsInHand[desirable_card]


func activateCard() -> CardData:
	_cardActivationAnimation()
	return .activateCard()

func _cardActivationAnimation() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	
	
	var newCardPackedScene = preload(cardPath)
	var newCard = newCardPackedScene.instance()
	newCard.cardData = card
	
	newCard.position = cardPos
	newCard.scale = Vector2(0.1, 0.1)
	
	.add_child(newCard)
	
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(newCard, "scale", Vector2.ONE, 0.2)
	tween.tween_property(newCard, "position", newCard.position, 1.0)
	tween.tween_property(newCard, "position", discardPos, 0.5)
	
	yield(tween, "finished")
	
	newCard.queue_free()
	
	emit_signal("discard_animation_finished")
