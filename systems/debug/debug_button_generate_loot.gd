extends Button


@export var drop_table: ItemDropTable


func _on_pressed() -> void:
	InventoryManager.add_item(LootGenerator.generate_loot(drop_table))
