extends Node2D

class_name PhaseManager

signal transitioned(phase_name)

"""
Some kind of phase manager, would keep the code simpler
"""

onready var current_phase: Phase = null
onready var current_focused_player: Player = get_parent().get_node("Player")

var whitelist: CardWhitelist
var blacklist: CardWhitelist

func _ready() -> void:
	whitelist = CardWhitelist.new()
	blacklist = CardWhitelist.new()
	blacklist.blacklist = true
	
	for child in get_children():
		child.phase_manager = self

func _process(delta):
	current_phase.update_phase(delta)

func _unhandled_input(event):
	current_phase.handle_input(event)

# Changes current phase to new phase.
func transition_to(new_phase_name: String) -> void:
	current_phase = get_node(new_phase_name)
	current_phase.enter()
	emit_signal("transitioned", current_phase.name)
