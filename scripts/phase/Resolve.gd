extends Phase

#resolves trap card and modifies card

signal add_SP
signal change_topic

var card: CardData
var player: Player
var opponent: Player

func enter(_msg := {}):
	print("Resolve!")
	player = phase_manager.current_focused_player
	opponent = phase_manager.current_unfocused_player
	player.hand.changeState(phase_manager.blacklist)
	
	card = _msg["card"]
	
	# Executes modified card actions
	_resolve_actions(card)
	
	emit_signal("add_SP", card.SP)
	player.deck.graveyard.append(card)
	player.hand.activateCard()
	phase_manager.transition_to("End")

func update_phase(delta: float) -> void:
	pass

func _resolve_actions(card: CardData) -> void:
	if !card.actions.empty():
		for action in card.actions:
			# Collect args
			var action_arg_1: String = ""
			var action_arg_2: String = ""
			if action.size() > 1:
				action_arg_1 = action[1]
			if action.size() > 2:
				action_arg_2 = action[2]
			var action_arg_1_int = action_arg_1.to_int()
			var action_arg_2_int = action_arg_2.to_int()

			# Execute actions
			if "changetopic" in action[0]:
				emit_signal("change_topic", action_arg_1.to_lower())
			if "selfPerk" in action[0]:
				# Don't need to use whitelist for this?
				for card in player.hand.cardsInHand:
					if action_arg_1 in card.topic:
						card.SP += action_arg_2_int
			if "disableType" in action[0]:
				# For x turns
				if "transition" in action_arg_1:
					phase_manager.whitelist.transitionTimeout += action_arg_2_int
				if "trap" in action_arg_1:
					phase_manager.whitelist.trapTimeout += action_arg_2_int
				if "action" in action_arg_1:
					phase_manager.whitelist.actionTimeout += action_arg_2_int
			if "disableTopic" in action[0]:
				# Blocks transition cards for x turns
				if "future" in action_arg_1:
					phase_manager.whitelist.futureTimeout += action_arg_2_int
				if "intimacy" in action_arg_1:
					phase_manager.whitelist.intimacyTimeout += action_arg_2_int
				if "social" in action_arg_1:
					phase_manager.whitelist.socialTimeout += action_arg_2_int
				if "hobbies" in action_arg_1:
					phase_manager.whitelist.hobbiesTimeout += action_arg_2_int
				if "house" in action_arg_1:
					phase_manager.whitelist.houseTimeout += action_arg_2_int
			if "graveyardPerk" in action[0]:
				var graveyardCards = player.deck.graveyard
				for card in player.hand.cardsInHand:
					if graveyardCards > 0:
						card.SP += 1
						graveyardCards -= 1
			if "oppPerk" in action[0]:
				for card in opponent.hand.cardsInHand:
					if action_arg_1 in card.topic:
						card.SP += action_arg_2_int
			if "blockSP" in action[0]:
				card.SP = 0
