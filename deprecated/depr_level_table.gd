class_name DeprLevelTable
extends Resource


@export var max_level: int = 100
@export var base_xp: int = 100
@export var growth_factor: float = 1.12
@export var quadratic_multiplier: float = 1.0


func xp_to_next(level: int) -> int:
	if level < 1:
		level = 1
	
	var xp = base_xp * pow(level, 2) * pow(growth_factor, level - 1) * quadratic_multiplier
	return int(round(xp))


func total_xp_for_level(target_level: int) -> int:
	var total := 0
	for l in range(1, target_level):
		total += xp_to_next(l)
	
	return total