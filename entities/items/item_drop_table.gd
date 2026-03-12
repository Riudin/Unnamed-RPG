class_name ItemDropTable
extends Resource


@export var xp_reward: int = 10

@export var item_weights: Dictionary[ItemData, int] = {}


func roll_item() -> ItemData:
	if item_weights.is_empty():
		return null
	
	var total := 0
	for w in item_weights.values():
		total += w
	
	var roll := randi_range(1, total)
	var sum := 0

	for item in item_weights.keys():
		sum += item_weights[item]
		if roll <= sum:
			return item
	
	return null