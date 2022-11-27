extends Phase

var player: Player
var dialogue_array: Array

const dialog_path: String = "res://ui/DialogBox.tscn"

func enter(_msg := {}) -> void:
	print("Dialogue!")
	player = phase_manager.dialogue_player
	player.hand.changeState(phase_manager.blacklist)
	assert(_msg.has("dialogue"))
	dialogue_array = _msg["dialogue"]
	
	var dialogueBox = preload(dialog_path)
	var dialog_instance = dialogueBox.instance()
	dialog_instance.text_queue = dialogue_array
	add_child(dialog_instance)
	dialog_instance.connect("done_writing", self, "dialog_done")

func dialog_done() -> void:
	phase_manager.transition_to("End")
