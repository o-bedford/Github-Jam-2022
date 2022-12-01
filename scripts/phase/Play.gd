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
	emit_signal("can_pause", true)
	has_drawn = false
	player = phase_manager.current_focused_player
	phase_manager.whitelist.trapTimeout += 1
	player.hand.changeState(phase_manager.whitelist)
	player.hand.enableDrawing(true)
	print("Play! " + player.name)
	if player.name == "Player":
		emit_signal("set_message_box", "Play!", "Pick a card to put on the table, or draw another card if you can't play any!")
	else:
		emit_signal("set_message_box", "Ceighsey Play!", "Wait to see what Ceighsey plays!")

func update_phase(delta: float) -> void:
	#Able to draw card
	if  player.hand.cardDrawn && !has_drawn:
		player.draw()
		player.hand.changeState(phase_manager.whitelist)
		player.hand.enableDrawing(false)
		has_drawn = true
		emit_signal("turn_skipped")
		phase_manager.transition_to("End")

	#Moves to next phase once card has been selected
	#print(player.hand.cardSelected)
	
	if player.hand.cardSelected != -1:
		
		player.hand.enableDrawing(false)
		if phase_manager.card != null && player.hand.getSelectedCard().SP > phase_manager.card.SP:
			phase_manager.escalate = true
		phase_manager.card = player.hand.getSelectedCard()
		print(phase_manager.card.quip)
		#Change the topic in the resolve phase

		player.hand.activateCard()
		yield(player.hand, "discard_animation_finished")
		phase_manager.transition_to("Trap", {card = player.hand.getSelectedCard()})
