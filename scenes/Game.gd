extends Node2D

"""
ALL THE GAME LOGIC LET'S GOOOOOO. 

shall we do a state machine? 

The game is 
"""

const card = preload("res://entities/cardsystem/Card.tscn")
const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
const db_table = "Cards"

var cardDB:SQLite = SQLite.new()

var current_player: Player
var current_topic: String
var SP_meter: int = 0
var SP_range: Array = []

onready var player1: Player = $Player
onready var player2: Player = $PlayerAI
onready var phase_manager = $PhaseManager
onready var draw_phase = $PhaseManager/Draw
onready var play_phase = $PhaseManager/Play
onready var resolve_phase = $PhaseManager/Resolve
onready var trap_phase = $PhaseManager/Trap
onready var SP_Meter_node = $UI/SPMeter
onready var message_box: MessageBox = $UI/MessageBox

#big boi
func _ready() -> void:
	draw_phase.connect("set_message_box", self, "_set_message_box")
	play_phase.connect("set_message_box", self, "_set_message_box")
	play_phase.connect("change_topic", self, "_change_topic")
	trap_phase.connect("set_message_box", self, "_set_message_box")
	resolve_phase.connect("change_topic", self, "_change_topic")
	resolve_phase.connect("add_SP", self, "_add_SP")
	resolve_phase.connect("change_SP_range", self, "_change_SP_range")
	
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
	if Input.is_action_just_pressed("ui_down"):
		_add_SP(2)
#	pass

func populate_deck(deck:Deck) -> void:
	# Probably add a check for the amount of cards of each topic type
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
