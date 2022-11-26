extends Node2D

class_name Board


const cardPath: String = "res://entities/cardsystem/Card.tscn"
const smallCardPath: String = "res://entities/cardsystem/SmallCard.tscn"

var cardData: CardData
var card: Card = null
var smallCard: Card = null

var oldSmallCard: Card = null

onready var bigCardPos = $BigCardPos.position
onready var pathFollow = $Path2D/PathFollow2D

func newCard(newCard: CardData) -> void:
	cardData = newCard
	
	if smallCard:
		var newCardPackedScene = preload(smallCardPath)
		oldSmallCard = newCardPackedScene.instance()
		oldSmallCard.cardData = smallCard.cardData
		
		.call_deferred("add_child", oldSmallCard)
	
	pathFollow.unit_offset = 0
	
	var newCardPackedScene = preload(smallCardPath)
	smallCard = newCardPackedScene.instance()
	smallCard.cardData = newCard
	
	smallCard.connect("card_hovered", self, "_onCardHovered")
	smallCard.connect("card_unhovered", self, "_onCardUnhovered")
	
	pathFollow.call_deferred("add_child", smallCard)
	
	
	
	var newBigCardPackedScene = preload(cardPath)
	card = newBigCardPackedScene.instance()
	card.cardData = newCard
	
	card.position = bigCardPos
	card.visible = false
	
	.call_deferred("add_child", card)
	
	update()

func _draw() -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(pathFollow, "unit_offset", 1.0, 0.5)
	yield(tween, "finished")
	if oldSmallCard:
		oldSmallCard.queue_free()
	

func _onCardHovered() ->void:
	card.visible = true

func _onCardUnhovered() ->void:
	card.visible = false

func _ready() -> void:
	#newCard(CardData.new())
	pass
	
