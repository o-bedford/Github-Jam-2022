extends Phase

signal change_topic
signal turn_skipped

var player: Player
var is_human: bool
var has_drawn: bool = false

# Saves card data (actions)
# Add trap phase
# - new whitelist (trapList)
# - other player can play a card

func enter(_msg := {}):
	Global.perk = false
	emit_signal("can_pause", true)
	has_drawn = false
	
	print(phase_manager.whitelist.SP_range, " ", phase_manager.whitelist.topic)
	player = phase_manager.current_focused_player
	phase_manager.whitelist.trapTimeout += 1
	
	player.hand.enableDrawing(true,false)
	player.hand.changeState(phase_manager.whitelist)
	print("Play! " + player.name)
	if player.name == "Player":
		emit_signal("set_message_box", "Play!", "Pick a card to put on the table, or draw another card if you can't play any!")
	else:
		emit_signal("set_message_box", "Ceighsey Play!", "Wait to see what Ceighsey plays!")

func update_phase(delta: float) -> void:
	#Able to draw card
	if  player.hand.cardDrawn && !has_drawn:
		player.draw()
		player.hand.enableDrawing(false,false)
		player.hand.changeState(phase_manager.whitelist)
		has_drawn = true
		emit_signal("turn_skipped")
		phase_manager.transition_to("End")

	#Moves to next phase once card has been selected
	#print(player.hand.cardSelected)
	
	if player.hand.cardSelected != -1:
		
		player.hand.enableDrawing(false,false)
		if phase_manager.card != null && player.hand.getSelectedCard().SP > phase_manager.card.SP:
			Global.escalate = true
		else:
			Global.escalate = false
		phase_manager.card = player.hand.getSelectedCard()
		print("Played: ",phase_manager.card.quip)
		#Change the topic in the resolve phase

		player.hand.activateCard()
		yield(player.hand, "discard_animation_finished")
		phase_manager.turnSinceLastPlay = 0
		phase_manager.transition_to("Trap", {card = player.hand.getSelectedCard()})
