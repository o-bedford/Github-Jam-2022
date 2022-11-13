extends Phase

var player: Player

func enter() -> void:
	player = phase_manager.current_focused_player
	player.hand.enabled = false
	print("Draw ur cards!")

func update_phase(delta: float) -> void:
	#really really really basic draw phase. please flesh out.
	if Input.is_action_just_pressed("ui_accept"):
		player.hand.addCard(player.deck.drawCard())
		print(str(player.hand.cardsInHand[player.hand.size()-1]))
	if player.hand.size() > 1:
		print("hell yea")
		phase_manager.transition_to("Play")
