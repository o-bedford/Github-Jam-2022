extends Phase

var dialogue_array: Array

func enter(_msg := {}) -> void:
	assert(_msg.has("dialogue"))
	dialogue_array = _msg["dialogue"]
