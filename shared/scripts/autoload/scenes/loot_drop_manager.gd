extends Node
# TODO: this manager is intended to spawn loot as drops in the world. determine if we want that or not
# if yes, we also need a loot_item_scene consisting of a Sprite2d

@export var loot_item_scene: PackedScene


func spawn_loot(world_position: Vector2, loot: ItemInstance):
	if loot:
		var item = loot_item_scene.instantiate()
		item.loot = loot
		item.global_position = world_position
		get_tree().current_scene.add_child(item)