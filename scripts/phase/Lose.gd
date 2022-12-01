extends Phase

const dialog_path = "res://ui/DialogBox.tscn"
const lose_screen_path = "res://scenes/LoseScreen.tscn"

var player: Player
var opponent: Player

var dialogue: Array = [
	"Look at you, you embarassed both of us.",
	"Everyone's staring, I'm getting a million notifications on TikTok, Instagram, Tind—, I mean Reddit.",
	"Lets... Let's just go home. I have work tomorrow, remember?",
	"This stunt you pulled was so entirely irrelevant",
	"We're fine, and I'm not the reason for any issue you might have with me",
	"It's not me, it's you."
]

onready var heartbreak: AudioStreamPlayer = $Heartbreak

func enter(_msg := {}) -> void:
	BgMusic.audio_player.stop()
	BgMusic.stop_ambiance()
	heartbreak.play()
	emit_signal("can_pause", true)
	player.hand.changeState(phase_manager.blacklist)
	opponent.hand.changeState(phase_manager.blacklist)
	
	var dialogueBox = preload(dialog_path)
	var dialog_instance = dialogueBox.instance()
	dialog_instance.text_queue = dialogue
	add_child(dialog_instance)
	dialog_instance.connect("done_writing", self, "dialog_done")

func dialog_done() -> void:
	var lose_screen = preload(lose_screen_path)
	FancyFade.horizontal_paint_brush(lose_screen.instance(), 3.0)
