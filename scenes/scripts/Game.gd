extends Node2D

"""
ALL THE GAME LOGIC LET'S GOOOOOO. 

shall we do a state machine? 

we shall
"""

const card = preload("res://entities/cardsystem/Card.tscn")
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
const db_table = "Cards"

var cardDB:SQLite = SQLite.new()

var current_player: Player
var current_topic: String
var SP_meter: int = 0
var SP_range: Array = []
var viable_play_anims: Array = ["smug", "angry", "default"]
var viable_dialogue_anims: Array = ["angry", "furious", "smug"]
var viable_trap_anims: Array = ["angry", "smug", "default"]
var can_pause: bool = true

onready var player1: Player = $Player
onready var player2: Player = $PlayerAI
onready var phase_manager = $PhaseManager
onready var draw_phase = $PhaseManager/Draw
onready var play_phase = $PhaseManager/Play
onready var resolve_phase = $PhaseManager/Resolve
onready var trap_phase = $PhaseManager/Trap
onready var dialogue_phase = $PhaseManager/Dialogue
onready var SP_Meter_node = $UI/SPMeter
onready var message_box: MessageBox = $UI/MessageBox
onready var skip_turn_anim_player: AnimationPlayer = $SkipTurnAnimPlayer
onready var opponent_char: Node2D = $OpponentChar

#big boi
func _ready() -> void:
	print("game start")
	draw_phase.connect("set_message_box", self, "_set_message_box")
	play_phase.connect("set_message_box", self, "_set_message_box")
	play_phase.connect("change_topic", self, "_change_topic")
	play_phase.connect("turn_skipped", self, "_turn_skipped")
	trap_phase.connect("set_message_box", self, "_set_message_box")
	dialogue_phase.connect("new_dialog_instance", self, "_new_dialog_init")
	resolve_phase.connect("change_topic", self, "_change_topic")
	resolve_phase.connect("add_SP", self, "_add_SP")
	resolve_phase.connect("change_SP_range", self, "_change_SP_range")
	
	for phase in phase_manager.get_children():
		phase.connect("can_pause", self, "_change_pausability")
	
	phase_manager.connect("transitioned", self, "_change_opponent_anim")
	
	cardDB.path = "res://db/cards"
	randomize()
	
	_change_topic("any")
	#initializes both decks. 
	populate_deck(player1.deck)
	populate_deck(player2.deck)
	
	for i in range(5):
		player1.draw()
		player2.draw()
	
	#Testing phase manager. it works!
	phase_manager.current_focused_player = player1
	phase_manager.transition_to("Draw")
	print(phase_manager.current_phase)

func _process(delta) -> void:
#	print(phase_manager.current_focused_player.name + " " + phase_manager.current_phase.name)
	if phase_manager.current_phase.name == "Resolve":
		print("SP: " + str(SP_meter) + " | Current Player: " + phase_manager.current_focused_player.name + " | Topic: " + current_topic)
#	pass

func populate_deck(deck:Deck) -> void:
	# Probably add a check for the amount of cards of each topic type
	cardDB.read_only = true
	cardDB.open_db()
	cardDB.query("select * from " + db_table + ";")
	for i in range(0, cardDB.query_result.size()):
		var newCard = CardData.new()
		newCard.loadDataFromDB(cardDB.query_result[i])
		deck.deck.append(newCard)
	deck.shuffleDeck()

func _change_topic(topic: String) -> void:
	current_topic = topic
	player1.current_hand_topic = topic
	player2.current_hand_topic = topic
	print("Current topic: " + topic)

func _add_SP(amount: int) -> void:
	SP_meter += amount
	player1.current_hand_sp_limit = SP_meter
	player2.current_hand_sp_limit = SP_meter
#	print(SP_meter)
	SP_Meter_node.set_value(SP_meter)
	if SP_meter >= SP_Meter_node.meter.max_value:
		phase_manager.transition_to("Win")
	elif SP_meter <= SP_Meter_node.meter.min_value:
		phase_manager.transition_to("Lose")

func _change_SP_range(new_SP_range: Array) -> void:
	SP_range = new_SP_range

func _set_message_box(header: String, bodyText: String) -> void:
	if message_box.timer.is_stopped():
		print("test?")
		message_box.popup(header, bodyText)
	else:
		print("test??")
		message_box.timer.stop()
		message_box.popup(header, bodyText)

func _turn_skipped() -> void:
	skip_turn_anim_player.play("skip_turn_fade_in")
	yield(skip_turn_anim_player, "animation_finished")
	skip_turn_anim_player.play("skip_turn_fade_out")

func _new_dialog_init() -> void:
	dialogue_phase.dialog_instance.connect("next_line", self, "_change_opponent_anim_dialog")

func _change_opponent_anim(phase_name) -> void:
	match phase_name:
		"Play":
			var rand_index: int = randi() % viable_play_anims.size()
			opponent_char.set_anim(viable_play_anims[rand_index])
		"Trap":
			var rand_index: int = randi() % viable_trap_anims.size()
			opponent_char.set_anim(viable_trap_anims[rand_index])

func _change_opponent_anim_dialog() -> void:
	print("test")
	var rand_index: int = randi() % viable_dialogue_anims.size()
	opponent_char.set_anim(viable_dialogue_anims[rand_index])

func _change_pausability(_can_pause: bool) -> void:
	can_pause = _can_pause
