extends Node2D

onready var hand: Hand = $HandVisible

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
const db_table = "Cards"
var cardDB:SQLite = SQLite.new()

func _ready() -> void:
	cardDB.path = "res://db/cards"
	#initializes both decks. 
	add_card()

func add_card() -> void:
	# Probably add a check for the amount of cards of each topic type
	cardDB.open_db()
	cardDB.query("select * from " + db_table + ";")
	for i in range(0, cardDB.query_result.size()):
		var newCard = CardData.new()
		newCard.loadDataFromDB(cardDB.query_result[i])
		hand.addCard(newCard)

