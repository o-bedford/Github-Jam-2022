extends Node2D

class_name Phase

"""
Decides what phase of the round we are at.

For example, during Phase Draw, all cards are deactivated.

For now, use phase_manager.current_focused_player in phase scripts to access player stuff
"""

var phase_manager = null

# Basically _ready
func enter() -> void:
	pass

# Basically _process
func update_phase(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
