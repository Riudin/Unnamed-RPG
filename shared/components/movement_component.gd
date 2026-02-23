class_name MovementComponent
extends Node


@export var parent: CharacterBody2D

@export var movement_speed := 100.0


func move_toward(direction):
	if parent == null:
		return
	
	parent.velocity = direction * movement_speed
	parent.move_and_slide()
