extends Node2D

class_name PhaseManager

signal transitioned(phase_name)

"""
Some kind of phase manager, would keep the code simpler
"""

onready var current_phase: Phase = null
onready var current_focused_player: Player = get_parent().get_node("Player")
onready var current_unfocused_player: Player = get_parent().get_node("PlayerAI")
onready var resolve_phase: Phase = $Resolve

var whitelist: CardWhitelist
var blacklist: CardWhitelist
var trapList: CardWhitelist
var allowAllCards: CardWhitelist
var turn: int = 0

func _ready() -> void:
	whitelist = CardWhitelist.new()
	blacklist = CardWhitelist.new()
	trapList = CardWhitelist.new()
	allowAllCards = CardWhitelist.new()
	blacklist.blacklist = true
	
	resolve_phase.connect("add_SP", self, "_add_whitelist_SP")
	resolve_phase.connect("change_topic", self, "_change_topic")
	
	for child in get_children():
		child.phase_manager = self

func _process(delta):
	current_phase.update_phase(delta)

func _unhandled_input(event):
	current_phase.handle_input(event)

# Changes current phase to new phase.
func transition_to(new_phase_name: String, msg: Dictionary = {}) -> void:
	if not has_node(new_phase_name):
		return
	
	current_phase = get_node(new_phase_name)
	current_phase.enter(msg)
	emit_signal("transitioned", current_phase.name)

func _add_whitelist_SP(value):
	whitelist.SP += value
	blacklist.SP += value

func _change_topic(topic: String) -> void:
	whitelist.topic = topic
	blacklist.topic = topic
