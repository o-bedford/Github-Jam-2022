extends Phase

signal add_SP
signal change_topic

var card: CardData
var player: Player

func enter():
	print("Resolve")
	player = phase_manager.current_focused_player
	if player.name == "Player":
		player.hand.changeState(0, "")
	
	card = player.hand.activateCard()
	emit_signal("add_SP", card.SP)
	
#	print(card.actions)
	if !card.actions.empty():
		for action in card.actions:
			if action[0] == "changetopic":
				emit_signal("change_topic", action[1])
			if action[0] == "perk":
				for card in player.hand.cardsInHand:
					if card.topic == action[1]:
						card.SP += action[2]
#			if action[0] == "swap":
	
	phase_manager.transition_to("End")

func update_phase(delta: float) -> void:
	pass
