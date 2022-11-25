extends Phase

var selectedCard: CardData
var opponentCard: CardData
var modifiedCard: CardData

var opponent: Player

onready var trapTimer: Timer = $TrapTimer

func enter(_msg := {}):
	trapTimer.start()
	opponent = phase_manager.current_unfocused_player
	opponent.hand.changeState(phase_manager.trapList)
	print("Trap! " + opponent.name)
	if _msg.has("card"):
		selectedCard = _msg["card"]
		modifiedCard = selectedCard

func update_phase(delta:float) -> void:
#	print(trapTimer.time_left)
	# Allow opponent to play trap card
	if opponent.hand.cardSelected != -1:
		modifiedCard.SP += opponentCard.SP
		modifiedCard.actions.append_array(opponentCard.actions)
		phase_manager.transition_to("Resolve", {card = modifiedCard})

func _on_TrapTimer_timeout():
	phase_manager.transition_to("Resolve", {card = modifiedCard})
