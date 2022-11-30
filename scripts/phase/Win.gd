extends Phase

const dialog_path = "res://ui/DialogBox.tscn"
const end_cutscene_path = "res://scenes/PostGameStory.tscn"

var player: Player
var opponent: Player

var dialogue: Array = [
	"You...",
	"You really...",
	"You really want to break up with me?",
	"Why?",
	"After all I've done for you, THIS is how I'm repaid?",
	"Wait, please don't go.",
	"I'll make it up to you— I'll, I'll start washing my legs! I'll help pay off the rent, I'll finally call you pr—",
	"Pret—",
	"Nope, still can't do it.",
	"You CAN'T leave, I financially need you to survive!",
	"No, no—",
	"NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
]

func enter(_msg := {}) -> void:
	player = phase_manager.current_focused_player
	opponent = phase_manager.current_unfocused_player
	player.hand.changeState(phase_manager.blacklist)
	opponent.hand.changeState(phase_manager.blacklist)
	
	var dialogueBox = preload(dialog_path)
	var dialog_instance = dialogueBox.instance()
	dialog_instance.text_queue = dialogue
	add_child(dialog_instance)
	dialog_instance.connect("done_writing", self, "dialog_done")

func dialog_done() -> void:
	var end_cutscene = preload(end_cutscene_path)
	FancyFade.horizontal_paint_brush(end_cutscene.instance(), 4.0)
