extends Phase

var card: CardData
var player: Player

func enter():
	player = phase_manager.current_focused_player
	var selectedCard = player.hand.cardSelected
	card = player.hand.cardsInHand[selectedCard]
	print("Resolve")
	print(card.actions)

func update_phase(delta: float) -> void:
	pass
