class_name Room
extends Resource


enum Type {NOT_ASSIGNED, MONSTER, ELITE, BOSS, CAMPFIRE, SHRINE}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected: bool = false

@export var enemy_level: int = 0

# for debugging purposes. A Campfire at row 2 will display as "2 (C)"
func _to_string() -> String:
	return "%s (%s)" % [row, Type.keys()[type][0]]
