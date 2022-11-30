extends Phase

var player: Player
var opponent: Player

func enter(_msg := {}):
	emit_signal("can_pause", true)
	if phase_manager.current_focused_player == phase_manager.get_parent().get_node("Player"):
		phase_manager.current_focused_player = phase_manager.get_parent().get_node("PlayerAI")
		phase_manager.current_unfocused_player = phase_manager.get_parent().get_node("Player")
	else:
		phase_manager.current_focused_player = phase_manager.get_parent().get_node("Player")
		phase_manager.current_unfocused_player = phase_manager.get_parent().get_node("PlayerAI")
	
	player = phase_manager.current_focused_player
	opponent = phase_manager.current_unfocused_player
	print("End! " + opponent.name)
	player.hand.changeState(phase_manager.allowAllCards)
	opponent.hand.changeState(phase_manager.allowAllCards)
	
	if player.name == "Player":
		emit_signal("set_message_box", "Lose a few cards!", "Get rid of a few cards to get back down to " + str(player.max_hand_size) + "!")

func update_phase(delta: float) -> void:
	# Discard cards to reach hand size
	if player.hand.cardSelected != -1:
		player.hand.disCard(player.hand.cardSelected)
	if opponent.hand.cardSelected != -1:
		opponent.hand.disCard(opponent.hand.cardSelected)
	if player.hand.size() <= player.max_hand_size && opponent.hand.size() <= opponent.max_hand_size:
		phase_manager.transition_to("Draw")
	
