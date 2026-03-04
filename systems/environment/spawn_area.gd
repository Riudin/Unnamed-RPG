class_name SpawnArea
extends Area2D


@export var min_entities: int = 0
@export var max_entities: int = 1

var current_entities: int = 0

@onready var collision_shape: CollisionShape2D = %CollisionShape2D

var area_start: Vector2 = Vector2.ZERO
var area_end: Vector2 = Vector2.ZERO


func _ready() -> void:
	area_start.x = collision_shape.global_position.x - collision_shape.shape.size.x / 2
	area_start.y = collision_shape.global_position.y - collision_shape.shape.size.y / 2
	area_end.x = collision_shape.global_position.x + collision_shape.shape.size.x / 2
	area_end.y = collision_shape.global_position.y + collision_shape.shape.size.y / 2