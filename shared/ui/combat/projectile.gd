class_name Projectile
extends Node2D


@export var target: Vector2
@export var speed: float
@export var animation: String

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D


func _ready() -> void:
	animated_sprite.play(animation)


func _process(delta: float) -> void:
	look_at(target)
	var direction := (target - global_position).normalized()

	global_position += direction * speed * delta

	if global_position.distance_to(target) < 5.0:
		queue_free()
