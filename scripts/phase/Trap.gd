extends Phase

var selectedCard: CardData
var opponentCard: CardData
var modifiedCard: CardData

var opponent: Player
var player: Player

onready var trapTimer: Timer = $TrapTimer

func enter(_msg := {}):
	emit_signal("can_pause", false)
#	trapTimer.start()
	opponent = phase_manager.current_unfocused_player
	opponent.hand.changeState(phase_manager.trapList)
	
	opponent.hand.enableDrawing(true)
	
	player = phase_manager.current_focused_player
	player.hand.changeState(phase_manager.blacklist)
	
	print("Trap! " + opponent.name)
	if opponent.name == "Player":
		emit_signal("set_message_box", "Trap!", "Pick a card to counteract your opponent's card!")
	if opponent.name == "PlayerAI":
		emit_signal("set_message_box", "Ceighsey Trap!", "There's a chance that your card will be modified!")
	
	if _msg.has("card"):
		selectedCard = phase_manager.card
		phase_manager.board.newCard(phase_manager.card)
		modifiedCard = selectedCard

func update_phase(delta:float) -> void:
	if  opponent.hand.cardDrawn:
		opponent.hand.enableDrawing(false)
		print("Trap Draw")
		phase_manager.transition_to("Resolve")
		
	if opponent.hand.cardSelected != -1:
		
		opponent.hand.enableDrawing(false)
		opponentCard = opponent.hand.getSelectedCard()
		## TODO: Change phase_manager.card based on opponentCard
		modifiedCard.SP += opponentCard.SP
		modifiedCard.actions.append_array(opponentCard.actions)
		if !opponentCard.dialog.empty():
			modifiedCard.dialog = opponentCard.dialog
		phase_manager.card = modifiedCard
		
		print("Trap Choose")

		opponent.hand.activateCard()
		yield(opponent.hand, "discard_animation_finished")
		phase_manager.transition_to("Resolve")

func _on_TrapTimer_timeout():
	phase_manager.transition_to("Resolve")
