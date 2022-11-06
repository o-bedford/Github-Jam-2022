extends Node2D

"""
ALL THE GAME LOGIC LET'S GOOOOOO. 

shall we do a state machine? 

The game is 
"""

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
const db_table = "Cards"

var cardDB:SQLite = SQLite.new()

onready var player1: Player = $Player
onready var player2: Player = $PlayerAI


#big boi
func _ready() -> void:
	cardDB.path = "res://db/cards"
	#initializes both decks. 
	populate_deck(player1.deck)
	populate_deck(player2.deck)
	for i in player1.deck.deck:
		print(i.quip)
	
	var testCard = Card.new()
	add_child(testCard)
	testCard.cardData = player1.deck.drawCard()
	print(testCard.cardData.quip)

func populate_deck(deck:Deck) -> void:
	# Probably add a check for the amount of cards of each topic type
	cardDB.open_db()
	cardDB.query("select * from " + db_table + ";")
	for i in range(0, cardDB.query_result.size()):
		var newCard = CardData.new()
		newCard.loadDataFromDB(cardDB.query_result[i])
		deck.deck.append(newCard)
