extends Phase

signal add_SP
signal change_topic

var card: CardData
var player: Player

func enter():
	print("Resolve")
	player = phase_manager.current_focused_player
	player.hand.changeState(phase_manager.blacklist)
	
	card = player.hand.activateCard()
	
	####################################
	emit_signal("add_SP", card.SP)
	
#	if !card.actions.empty():
#		for action in card.actions:
#			if action[0] == "changetopic":
#				emit_signal("change_topic", action[1])
#			if action[0] == "perk":
#				for card in player.hand.cardsInHand:
#					if card.topic == action[1]:
#						card.SP += action[2]
#			if action[0] == "swap":
	#####################################
	#Replace with changing the whitelist:
	#For example:
	#   if action is changetopic:
	#         phase_manager.whitelist.topic = action_result
	if !card.actions.empty():
		for action in card.actions:
			# Collect args
			var action_arg_1: String = action[1]
			var action_arg_2: String = ""
			if action[2] != null:
				action_arg_2 = action[2]
				
			# Execute actions
			if "changetopic" in action[0]:
				emit_signal("change_topic", action_arg_1)
			if "selfPerk" in action[0]:
				# Don't need to use whitelist for this?
				for card in player.hand.cardsInHand:
					if action_arg_1 in card.topic:
						card.SP += action_arg_2
			if "disableTopic" in action[0]:
				if "transition" in action_arg_1:
					phase_manager.whitelist.canPlayTransition = false
				if "trap" in action_arg_1:
					phase_manager.whitelist.canPlayTrap = false
				if "action" in action_arg_1:
					phase_manager.whitelist.canPlayAction = false
	
	phase_manager.transition_to("End")

func update_phase(delta: float) -> void:
	pass
