extends Phase

var player: Player
var is_human: bool = false

func enter() -> void:
	player = phase_manager.current_focused_player
	if player.name == "Player":
		player.hand.enabled = false
		is_human = true
	else:
		is_human = false
	print("Draw ur cards " + player.name + "!")

func update_phase(delta: float) -> void:
	#really really really basic draw phase. please flesh out.
	if Input.is_action_just_pressed("ui_accept") && is_human:
		player.hand.addCard(player.deck.drawCard())
		print(str(player.hand.cardsInHand[player.hand.size()-1]))
	if !is_human:
		ai_draw()
	if player.hand.size() > player.max_hand_size-1:
		print("hell yea")
		phase_manager.transition_to("Play")

func ai_draw() -> void:
	print("yea")
	for i in player.max_hand_size-player.hand.size():
		player.hand.addCard(player.deck.drawCard())
		print(str(player.hand.size()) + " " + player.hand.cardsInHand[player.hand.size()-1].quip)
