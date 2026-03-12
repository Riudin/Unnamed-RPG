class_name SpawnManager
extends Node


#References
@onready var world: Node2D = %World
@onready var enemy_container: Node = %EnemyContainer
@onready var enemy_scene: PackedScene = preload("uid://bfqknvi0je5a8")
@onready var orc_resource: Resource = preload("uid://b2juo74fyf2wm") # TODO: this is a placeholder until different enemies are stored somewhere

var active_level: Level = null
var active_spawn_areas: Array[SpawnArea] = []


func _ready() -> void:
	active_level = get_active_level()
	active_spawn_areas = active_level.spawn_areas

	call_deferred("check_spawn_count")


func get_active_level():
	for child in world.get_children():
		if child is Level:
			return child


func check_spawn_count():
	for area in active_spawn_areas:
		if area.current_entities < area.min_entities:
			var amount = randi_range(area.min_entities - area.current_entities, area.max_entities - area.current_entities)
			spawn_entities(area, amount)


func spawn_entities(area, amount):
	for i in range(amount):
		var new_enemy = enemy_scene.instantiate()
		new_enemy.enemy_data = orc_resource # TODO: this is a placeholder until different enemies are stored somewhere. At that point this needs to be randomized.
		new_enemy.global_position = calculate_spawn_position(area)
		enemy_container.add_child(new_enemy)


func calculate_spawn_position(area):
	var spawn_pos_x := randf_range(area.area_start.x, area.area_end.x)
	var spawn_pos_y := randf_range(area.area_start.y, area.area_end.y)
	var spawn_pos := Vector2(spawn_pos_x, spawn_pos_y)
	return spawn_pos
