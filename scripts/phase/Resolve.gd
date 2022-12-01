extends Phase

#resolves trap card and modifies card

signal add_SP
signal change_topic
signal change_SP_range

var card: CardData
var player: Player
var opponent: Player
var target: Player

func enter(_msg := {}):
	emit_signal("can_pause", true)
	player = phase_manager.current_focused_player
	opponent = phase_manager.current_unfocused_player
	target = opponent
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
		var other_target: bool = false
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
			if "changeTarget" in action[0]:
				if "self" in action_arg_1:
					target = player
				elif "opponent" in action_arg_1:
					target = opponent
			if "changeAttack" in action[0]:
				card.SP += action_arg_1_int
			if "selfPerk" in action[0]:
				if !other_target:
					for card in player.hand.cardsInHand:
						card.SP += action_arg_1_int
				else:
					for card in opponent.hand.cardsInHand:
						card.SP += action_arg_1_int
				Global.perk = true
			if "oppPerk" in action[0]:
				for card in target.hand.cardsInHand:
					card.SP += action_arg_1_int
				Global.perk = true
			if "ceil" in action[0]:
				phase_manager.whitelist.SP_range = [phase_manager.card.SP-2, phase_manager.card.SP]
			if "floor" in action[0]:
				phase_manager.whitelist.SP_range = [phase_manager.card.SP, phase_manager.card.SP+2]
			if "changePerkTarget" in action[0]:
				other_target = true
			if "spClear" in action[0]:
				phase_manager.whitelist.SP_range = []
			if "topicEnder" in action[0]:
				emit_signal("change_topic", "any")
				phase_manager.whitelist.topic = "any"
			if "draw" in action[0]:
				if "self" in action_arg_1:
					for i in action_arg_2_int:
						player.draw()
				if "opponent" in action_arg_1:
					for i in action_arg_2_int:
						target.draw()
			if "copy" in action[0]:
				opponent.hand.addCard(phase_manager.card)
			if "changeAttack" in action[0]:
				emit_signal("add_SP", action_arg_1_int)
			if "topic" in action[0]:
				phase_manager.whitelist.topic = action_arg_1
			
