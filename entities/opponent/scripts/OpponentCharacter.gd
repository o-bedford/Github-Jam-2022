extends Node2D


onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("default")

func set_anim(anim: String) -> void:
	if anim_player.get_animation_list().has(anim):
		for child in get_children():
			if child is Sprite && child.name != anim:
				child.visible = false
			elif child is Sprite && anim in child.name:
				child.visible = true
		anim_player.play(anim)
