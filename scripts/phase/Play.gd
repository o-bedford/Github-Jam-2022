extends Phase

signal change_topic

var player: Player
var is_human: bool
var has_drawn: bool = false

# Saves card data (actions)
# Add trap phase
# - new whitelist (trapList)
# - other player can play a card

func enter(_msg := {}):
	has_drawn = false
	player = phase_manager.current_focused_player
	phase_manager.whitelist.trapTimeout += 1
	player.hand.changeState(phase_manager.whitelist)
	player.hand.enableDrawing(true)
	print("Play! " + player.name)
	emit_signal("set_message_box", "Play!", "Pick a card to put on the table, or draw another card if you can't play any!")
	
	if player.name == "Player":
		is_human = true
	else:
		is_human = false

func update_phase(delta: float) -> void:
	#Able to draw card
	if  player.hand.cardDrawn && !has_drawn:
		player.draw()
		player.hand.changeState(phase_manager.whitelist)
		player.hand.enableDrawing(false)
		has_drawn = true
		phase_manager.transition_to("End")

	#Moves to next phase once card has been selected
	#print(player.hand.cardSelected)
	
	if player.hand.cardSelected != -1:
		
		player.hand.enableDrawing(false)
		phase_manager.card = player.hand.getSelectedCard()
		print(phase_manager.card.quip)
		#Change the topic in the resolve phase

		player.hand.activateCard()
		yield(player.hand, "discard_animation_finished")
		phase_manager.transition_to("Trap", {card = player.hand.getSelectedCard()})
		
#	if is_human:
#		if player.hand.cardSelected != -1:
#			print(player.hand.getSelectedCard().quip)
#			emit_signal("change_topic", player.hand.getSelectedCard().topic)
#			match player.hand.getSelectedCard().topic:
#				"future":
#					for timeout in phase_manager.trapList.topicTimeouts:
#						if timeout != phase_manager.trapList.futureTimeout:
#							timeout += 1
#				"intimacy":
#					for timeout in phase_manager.trapList.topicTimeouts:
#						if timeout != phase_manager.trapList.intimacyTimeout:
#							timeout += 1
#				"social":
#					for timeout in phase_manager.trapList.topicTimeouts:
#						if timeout != phase_manager.trapList.socialTimeout:
#							timeout += 1
#				"growth":
#					for timeout in phase_manager.trapList.topicTimeouts:
#						if timeout != phase_manager.trapList.growthTimeout:
#							timeout += 1
#
#			player.hand.activateCard()
#			yield(player.hand, "discard_animation_finished")
#			phase_manager.transition_to("Trap", {card = player.hand.getSelectedCard()})
#	else:
#		ai_play()
#		phase_manager.transition_to("Trap")

func ai_play() -> void:
	var desirable_card: CardData
	var cards_in_topic: Array = []
	for card in player.hand.cardsInHand:
#		print(card.topic + " " + player.current_hand_topic)
		if player.current_hand_topic in card.topic.to_lower() || player.current_hand_topic == "any":
			cards_in_topic.append(card)
			print(card.quip)
	
	var previous_card: CardData = CardData.new()
	previous_card.weight = -1.0
	for card in cards_in_topic:
		if card.weight > previous_card.weight:
			desirable_card = card
			previous_card = card
	
	
	if desirable_card == null:
		phase_manager.transition_to("End")
	else:
		print(desirable_card.quip)
		player.hand.cardSelected = player.hand.cardsInHand.find(desirable_card, 0)
