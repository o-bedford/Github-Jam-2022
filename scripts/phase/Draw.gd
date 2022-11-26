extends Phase

var player: Player
var opponent: Player
var is_human: bool = false

onready var draw_timer = $DrawTimer

func enter(_msg := {}) -> void:
	phase_manager.turn += 1
	for timeout in phase_manager.whitelist.timeouts:
		if timeout > 0:
			timeout -= 1
	
	player = phase_manager.current_focused_player
	opponent = phase_manager.current_unfocused_player
	player.hand.changeState(phase_manager.blacklist)
	player.hand.enableDrawing(false)
	opponent.hand.changeState(phase_manager.blacklist)
	print("Draw! " + player.name)
	
	draw_timer.start()
	
#	if player.name == "Player":
#		is_human = true
#	else:
#		is_human = false
	#Draw 1 card
#	if phase_manager.turn == 0:
#		for n in player.max_hand_size:
#			player.hand.addCard(player.deck.drawCard())
#		for n in opponent.max_hand_size:
#			opponent.hand.addCard(player.deck.drawCard())
#	while player.hand.size() < player.max_hand_size:
#		player.hand.addCard(player.deck.drawCard())
#	while opponent.hand.size() < opponent.max_hand_size:
#		opponent.hand.addCard(opponent.deck.drawCard())
#	for card in player.hand.cardsInHand:
#		print(str(card.quip))
#	phase_manager.transition_to("Play")

func _on_DrawTimer_timeout():
	if player.hand.size() < player.max_hand_size:
		player.hand.addCard(player.deck.drawCard())
		print(player.hand.cardsInHand[player.hand.size()-1].type)
	if opponent.hand.size() < opponent.max_hand_size:
		opponent.hand.addCard(opponent.deck.drawCard())
	if player.hand.size() < player.max_hand_size || opponent.hand.size() < opponent.max_hand_size:
		draw_timer.start()
	if player.hand.size() == player.max_hand_size && opponent.hand.size() == opponent.max_hand_size:
		phase_manager.transition_to("Play")
