extends Phase

func enter():
	if phase_manager.current_focused_player == phase_manager.get_parent().get_node("Player"):
		phase_manager.current_focused_player = phase_manager.get_parent().get_node("PlayerAI")
		phase_manager.current_unfocused_player = phase_manager.get_parent().get_node("Player")
	else:
		phase_manager.current_focused_player = phase_manager.get_parent().get_node("Player")
		phase_manager.current_unfocused_player = phase_manager.get_parent().get_node("PlayerAI")
	phase_manager.transition_to("Draw")
