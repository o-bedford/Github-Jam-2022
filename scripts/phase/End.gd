extends Phase

var player: Player
var opponent: Player

func enter(_msg := {}):
	if phase_manager.current_focused_player == phase_manager.get_parent().get_node("Player"):
		phase_manager.current_focused_player = phase_manager.get_parent().get_node("PlayerAI")
		phase_manager.current_unfocused_player = phase_manager.get_parent().get_node("Player")
	else:
		phase_manager.current_focused_player = phase_manager.get_parent().get_node("Player")
		phase_manager.current_unfocused_player = phase_manager.get_parent().get_node("PlayerAI")
	
	player = phase_manager.current_focused_player
	opponent = phase_manager.current_unfocused_player
	player.hand.changeState(phase_manager.allowAllCards)
	opponent.hand.changeState(phase_manager.allowAllCards)
#	phase_manager.transition_to("Draw")
	# Discard cards to reach hand size

func update_phase(delta: float) -> void:
	if player.hand.size() <= player.max_hand_size && opponent.hand.size() <= opponent.max_hand_size:
		phase_manager.transition_to("Draw")
