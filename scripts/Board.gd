extends Node2D

class_name Board


const cardPath: String = "res://entities/cardsystem/Card.tscn"
const smallCardPath: String = "res://entities/cardsystem/SmallCard.tscn"

var cardData: CardData
var card: Card = null
var smallCard: Card = null

var numCards = 0
var cardThickness = 10

var oldSmallCard: Card = null

onready var bigCardPos = $BigCardPos.position
onready var pathFollow = $Path2D/PathFollow2D
onready var oldCards = $OldCards
onready var pathPos = $Path2D.position

func clear() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(smallCard, "position", pathPos, 0.1)
	
	for child in oldCards.get_children():
		tween.tween_property(child, "position", pathPos, 0.1)
	
	yield(tween,"finished")
	
	smallCard.queue_free()
	smallCard = null
	for child in oldCards.get_children():
		child.queue_free()
		child = null
	numCards = 0

func newCard(newCard: CardData) -> void:
	cardData = newCard
	
	if smallCard:
		var newCardPackedScene = preload(smallCardPath)
		oldSmallCard = newCardPackedScene.instance()
		oldSmallCard.cardData = smallCard.cardData
		oldSmallCard.position = smallCard.position
		oldSmallCard.rotation = smallCard.rotation
		oldCards.call_deferred("add_child", oldSmallCard)
		
		card.queue_free()
		smallCard.queue_free()
	
	pathFollow.unit_offset = 0
	
	var newCardPackedScene = preload(smallCardPath)
	smallCard = newCardPackedScene.instance()
	
	for i in range(newCard.actions.size()):
		if newCard.actions[i][0] == "topic":
			newCard.topic = newCard.actions[i][1]
	
	smallCard.cardData = newCard
	
	smallCard.rotation = rand_range(-PI/36,PI/36)
	
	smallCard.position.y -= cardThickness*numCards
	numCards += 1
	
	smallCard.connect("card_hovered", self, "_onCardHovered")
	smallCard.connect("card_unhovered", self, "_onCardUnhovered")
	
	pathFollow.call_deferred("add_child", smallCard)
	
	
	
	var newBigCardPackedScene = preload(cardPath)
	card = newBigCardPackedScene.instance()
	card.cardData = newCard
	
	card.position = bigCardPos
	card.visible = false
	card.scale = Vector2.ZERO
	
	.call_deferred("add_child", card)
	
	update()

func _draw() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(pathFollow, "unit_offset", 1.0, 0.5)
	

func _onCardHovered() ->void:
	card.visible = true
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(card, "scale", Vector2.ONE, 0.1)

func _onCardUnhovered() ->void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(card, "scale", Vector2.ZERO, 0.1)
	yield(tween, "finished")
	card.visible = false

func _ready() -> void:
	#newCard(CardData.new())
	pass
	
