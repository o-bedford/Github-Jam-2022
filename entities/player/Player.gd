extends Node2D

class_name Player

"""
this is the code for a player. A player has a hand, and a deck
"""

var max_hand_size = 5

var hand_enabled: bool

onready var hand: Hand = $Hand

onready var deck: Deck = $Deck
