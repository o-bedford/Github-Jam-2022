extends Node2D

onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("default")

func set_anim(anim: String) -> void:
	if anim_player.get_animation_list().has(anim):
		anim_player.play(anim)
