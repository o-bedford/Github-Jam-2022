extends Phase

var player: Player

func enter():
	print("Play!")
	player = phase_manager.current_focused_player
	if player.name == "Player":
		player.hand.enabled = true

func update_phase(delta: float) -> void:
	#Moves to next phase once card has been selected
	print(player.hand.cardSelected)
	for card in player.hand.cardsInstances:
		if card.isSelected:
			phase_manager.transition_to("Resolve")
