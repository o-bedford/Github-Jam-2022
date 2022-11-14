extends Node2D

class_name Player

"""
this is the code for a player. A player has a hand, and a deck
"""

var max_hand_size = 5

var current_hand_topic: String = ""
var current_hand_sp_limit: int = 0

onready var hand: Hand = $Hand

onready var deck: Deck = $Deck
