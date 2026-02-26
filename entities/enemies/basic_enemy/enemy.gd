class_name Enemy
extends CharacterBody2D


@export var enemy_data: EnemyData

@onready var sprite: Sprite2D = %Sprite2D


func _ready() -> void:
	if enemy_data == null:
		prints("No enemy_data found on", self )
		return
	
	sprite.texture = enemy_data.texture