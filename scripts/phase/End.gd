extends Phase

var player: Player
var opponent: Player

func enter(_msg := {}):
	emit_signal("can_pause", true)
	
	phase_manager.turnSinceLastPlay += 1
	
	if phase_manager.turnSinceLastPlay > 4:
		phase_manager.whitelist = CardWhitelist.new()
		phase_manager.board.clear()
	
	if phase_manager.current_focused_player == phase_manager.get_parent().get_node("Player"):
		phase_manager.current_focused_player = phase_manager.get_parent().get_node("PlayerAI")
		phase_manager.current_unfocused_player = phase_manager.get_parent().get_node("Player")
	else:
		phase_manager.current_focused_player = phase_manager.get_parent().get_node("Player")
		phase_manager.current_unfocused_player = phase_manager.get_parent().get_node("PlayerAI")
	
	player = phase_manager.current_focused_player
	opponent = phase_manager.current_unfocused_player
	
	print("End! " + opponent.name)
	if player.hand.size() > player.max_hand_size:
		player.hand.enableDrawing(false, false)
		player.hand.changeState(phase_manager.allowAllCards)
	else:
		player.hand.enableDrawing(false, false)
		player.hand.changeState(phase_manager.blacklist)
	
	opponent.hand.enableDrawing(false, false)
	opponent.hand.changeState(phase_manager.blacklist)
	
	player.hand.cardSelected = -1
	if player.name == "Player":
		emit_signal("set_message_box", "Lose a few cards!", "Get rid of a few cards to get back down to " + str(player.max_hand_size) + "!")

func update_phase(delta: float) -> void:
	# Discard cards to reach hand size
	if player.hand.cardSelected != -1:
		print("player Drew ", player.hand.cardSelected)
		player.hand.justDiscard(player.hand.cardSelected)
	if player.hand.size() <= player.max_hand_size:
		phase_manager.transition_to("Draw")
	
