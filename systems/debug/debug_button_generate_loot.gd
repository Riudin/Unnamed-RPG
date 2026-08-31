extends Button


@export var looted_enemy: EnemyData


func _on_pressed() -> void:
	looted_enemy.base_drop_chance = 1

	var loot_items: Array[ItemInstance] = LootGenerator.generate_loot(looted_enemy)

	if loot_items.size() > 0:
		for item in loot_items:
			InventoryManager.add_item(item)
