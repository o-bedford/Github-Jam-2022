extends Phase

var selectedCard: CardData
var opponentCard: CardData
var modifiedCard: CardData

var opponent: Player

onready var trapTimer: Timer = $TrapTimer

func enter(_msg := {}):
	trapTimer.start()
	print("Trap!")
	opponent = phase_manager.current_unfocused_player
	if _msg.has("card"):
		selectedCard = _msg["card"]
		modifiedCard = selectedCard

func update_phase(delta:float) -> void:
	# Allow opponent to play trap card
	opponent.hand.changeState(phase_manager.trapList)
	if opponent.hand.cardSelected != -1:
		modifiedCard.SP += opponentCard.SP
		phase_manager.transition_to("Resolve", {card = modifiedCard})
	pass

func _on_TrapTimer_timeout():
	phase_manager.transition_to("Resolve", {card = modifiedCard})
