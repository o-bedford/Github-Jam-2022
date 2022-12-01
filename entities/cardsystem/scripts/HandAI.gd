extends Hand

"""
hand visible inherited class. basically the same thing as Hand except
the AI gets to choose their cards
"""
var cardCanSelect: Array = []
var card : CardData

var rng = RandomNumberGenerator.new()

const cardPath: String = "res://entities/cardsystem/Card.tscn"

var randomness: int = 75

onready var cardPos: Vector2 = $CardPos.position
onready var discardPos: Vector2 = $DiscardPos.position
onready var timer: Timer = $AITimer

func _ready():
	randomize()

func changeState(whitelist: CardWhitelist) -> void:
	cardCanSelect = []
	for i in range(cardsInHand.size()):
		cardCanSelect.append(whitelist.checkCard(cardsInHand[i]) )
	call_deferred("chooseCard")

### THIS IS THE AI LOGIC IT HAS TO CHOOSE BETWEEN SELECTABLE CARDS
func chooseCard() -> void:
	timer.wait_time = rand_range(1.0, 1.9)
	timer.start()
	
	yield(timer, "timeout")
	rng.randomize()
	
	var my_random_number = rng.randf_range(0, 100)
	var desirable_card: int = -1
	var previous_card: CardData = CardData.new()
	
	var previous_weight = -1.0
	for i in range(cardCanSelect.size()):
		if cardCanSelect[i]:
			my_random_number = rng.randf_range(0, 100)
			if (i == 0):
				if cardsInHand[i].weight > previous_weight:
					desirable_card = i
					previous_weight = cardsInHand[i].weight
			else:
				if (my_random_number  <= 75):
					print(my_random_number)
					if cardsInHand[i].weight > previous_weight:
						desirable_card = i
						previous_weight = cardsInHand[i].weight
	
	
	cardSelected = desirable_card
	if desirable_card == -1:
		if drawCard:
			cardDrawn = true
	else:
		card = cardsInHand[desirable_card]
		card.dialog = []
		card.SP *= -1

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
	
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(newCard, "scale", Vector2.ONE, 0.2)
	tween.tween_property(newCard, "position", newCard.position, 3.0)
	tween.tween_property(newCard, "position", discardPos, 0.5)
	
	yield(tween, "finished")
	
	newCard.queue_free()
	
	emit_signal("discard_animation_finished")
