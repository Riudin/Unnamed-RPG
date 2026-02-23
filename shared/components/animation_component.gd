class_name AnimationComponent
extends Node


@onready var anim_player: AnimationPlayer = %AnimationPlayer


func play_animation(anim):
	if not anim_player:
		print("ERROR: ANIMATION PLAYER NOT FOUND!")
		return
	
	anim_player.play(anim)