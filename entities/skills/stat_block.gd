class_name StatBlock
extends Resource

### Holds information about damage scaling through various means. Can for example be on an affix of an item, on the player or on a skill.
### Gets sent to DanageInstance and used in DamageSystem to calculate damage.


@export var increased_damage: float = 0.0
@export var increased_physical_damage: float = 0.0
@export var increased_fire_damage: float = 0.0
@export var increased_cold_damage: float = 0.0
@export var increased_lightning_damage: float = 0.0

@export var more_damage: float = 1.0

@export var crit_chance: float = 0.05
@export var crit_multiplier: float = 1.5


func combine(other: StatBlock) -> StatBlock:
	var result = StatBlock.new()

	result.increased_damage = increased_damage + other.increased_damage
	result.increased_physical_damage = increased_physical_damage + other.increased_physical_damage
	result.increased_fire_damage = increased_fire_damage + other.increased_fire_damage
	result.increased_cold_damage = increased_cold_damage + other.increased_cold_damage
	result.increased_lightning_damage = increased_lightning_damage + other.increased_lightning_damage

	result.more_damage = more_damage * other.more_damage

	result.crit_chance = crit_chance + other.crit_chance
	result.crit_multiplier = crit_multiplier * other.crit_multiplier

	return result