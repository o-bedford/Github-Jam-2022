extends Phase

#resolves trap card and modifies card

signal add_SP
signal change_topic
signal change_SP_range

var card: CardData
var player: Player
var opponent: Player

func enter(_msg := {}):
	emit_signal("can_pause", true)
	player = phase_manager.current_focused_player
	opponent = phase_manager.current_unfocused_player
	player.hand.changeState(phase_manager.blacklist)
	print("Resolve! " + player.name)
	
	card = phase_manager.card
	
	# Executes modified card actions
	_resolve_actions(card)
	
#	emit_signal("change_topic", card.topic)
	emit_signal("add_SP", card.SP)
	
	player.deck.graveyard.append(card)
	if !card.dialog.empty():
		print(card.dialog)
		phase_manager.transition_to("Dialogue", {dialogue = card.dialog})
	else:
		phase_manager.transition_to("End")

func update_phase(delta: float) -> void:
	pass

func _wait() -> void:
	yield(get_tree().create_timer(0.3), "timeout")

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
			if "selfPerk" in action[0]:
				# Don't need to use whitelist for this?
				for card in player.hand.cardsInHand:
					if action_arg_1 in card.topic:
						card.SP += action_arg_2_int
				_wait()
			if "disableType" in action[0]:
				# For x turns
				if "transition" in action_arg_1:
					phase_manager.whitelist.transitionTimeout += action_arg_2_int
				if "trap" in action_arg_1:
					phase_manager.whitelist.trapTimeout += action_arg_2_int
				if "action" in action_arg_1:
					phase_manager.whitelist.actionTimeout += action_arg_2_int
				_wait()
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
				_wait()
			if "graveyardPerk" in action[0]:
				var graveyardCards = player.deck.graveyard
				var graveyardIter = graveyardCards.size()
				for card in player.hand.cardsInHand:
					if graveyardCards.size() > 0:
						card.SP += 1
						graveyardIter -= 1
				_wait()
			if "oppPerk" in action[0]:
				for card in opponent.hand.cardsInHand:
					if action_arg_1 in card.topic:
						card.SP += action_arg_2_int
				_wait()
			if "range" in action[0]:
				var new_SP_range = [action_arg_1_int, action_arg_2_int]
				phase_manager.whitelist.SP_range = new_SP_range
				emit_signal("change_SP_range", new_SP_range)
			if "blockSP" in action[0]:
				card.SP = 0
				_wait()
