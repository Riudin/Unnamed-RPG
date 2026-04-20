class_name StatBlock
extends Resource

### Holds information about damage scaling through various means. Can for example be on an affix of an item, on the player or on a skill.
### Gets sent to DanageInstance and used in DamageSystem to calculate damage.

### Rules for Variables:
###	Variables must be of type float (for percent increases) or int (for flat increases) to be combined.
### Variable name must include "more" or "multiplier" if stat is multiplicative.
### Variable name must not include "more" or "multiplier" if stat is additive.
### Variable must be serialized and saved to be combined. This is easiest achieved by using @export.


@export var increased_damage: float = 0.0
@export var increased_physical_damage: float = 0.0
@export var increased_fire_damage: float = 0.0
@export var increased_cold_damage: float = 0.0
@export var increased_lightning_damage: float = 0.0

@export var more_damage: float = 0.0
@export var more_physical_damage: float = 0.0
@export var more_fire_damage: float = 0.0
@export var more_cold_damage: float = 0.0
@export var more_lightning_damage: float = 0.0

@export var increased_fire_resistance: int = 0
@export var increased_cold_resistance: int = 0
@export var increased_lightning_resistance: int = 0

@export var crit_chance: float = 0.05
@export var crit_multiplier: float = 1.5


func combine(other: StatBlock) -> StatBlock:
	var result = StatBlock.new()
	
	for prop in get_property_list():
		if prop.type != TYPE_FLOAT and prop.type != TYPE_INT:
			continue
		if not (prop.usage & PROPERTY_USAGE_STORAGE):
			continue
		
		# Properties with "more" or "multiplier" in the name are multiplicative
		var is_multiplicative = "more" in prop.name or "multiplier" in prop.name
		var value = get(prop.name)
		var other_value = other.get(prop.name)
		
		result.set(prop.name, value * other_value if is_multiplicative else value + other_value)
	
	return result