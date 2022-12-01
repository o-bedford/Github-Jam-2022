extends Node

var next_sound: AudioStream

onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
onready var fadeOutTween: Tween = $FadeOutTween
onready var fadeInTween: Tween = $FadeInTween

func set_sound(sound: String) -> void:
	audio_player.volume_db = 0
	var sound_stream: AudioStream = load(sound)
	sound_stream.set_loop(true)
	audio_player.stream = sound_stream
	audio_player.play()
	next_sound = sound_stream

func set_sound_same_pos(sound: String) -> bool:
	if !audio_player.get_playback_position() >= audio_player.stream.get_length():
		var previous_pos: float = audio_player.get_playback_position()
		var sound_stream: AudioStream = load(sound)
		sound_stream.set_loop(true)
		audio_player.stream = sound_stream
		audio_player.play(previous_pos)
		return true
	return false

func fade_out(duration: float) -> void:
	fadeOutTween.interpolate_property(audio_player, "volume_db", 0, -80, duration, Tween.TRANS_SINE, Tween.EASE_IN)
	fadeOutTween.start()
	yield(fadeOutTween, "tween_completed")
	fadeOutTween.remove_all()

func fade_in(sound: String, duration: float) -> void:
	set_sound(sound)
	audio_player.volume_db = -80
	fadeInTween.interpolate_property(audio_player, "volume_db", -80, 0, duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	fadeInTween.start()
	yield(fadeInTween, "tween_completed")
	fadeOutTween.remove_all()
