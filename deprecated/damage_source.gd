class_name DamageSource
extends Resource

### Basic information about damage. Everything that adds a flat amount of damage to a DamageInstance has this, e.g. item affix, skill, etc.


enum DamageType {
	PHYSICAL,
	FIRE,
	COLD,
	LIGHTNING,
	CHAOS
}

@export var type: DamageType
@export var min_damage: float
@export var max_damage: float


'''
Old way, damage_data worked. keeping it for reference and to steal from

@export var source: NodePath # unused
@export var target: NodePath # unused
@export var skill_name: String = ""
@export var damage_type: String = "Physical"

@export var base_min_damage: float = 0.0
@export var base_max_damage: float = 0.0
@export var flat_added_damage: float = 0.0
@export var damage_variance_pct: float = 0.0
@export var chance_to_hit: float = 1.0

@export var crit_chance_pct: float = 0.0
@export var crit_multiplier: float = 2.0

# @export var attack_speed_pct: float = 0.0
# @export var cast_speed_pct: float = 0.0
# @export var hits_per_second: float = 0.0

@export var strength_scaling: float = 0.0
@export var dexterity_scaling: float = 0.0
@export var intelligence_scaling: float = 0.0
@export var level_scaling_multiplier: float = 1.0

@export var increased_damage_pct: float = 0.0
@export var more_damage_multiplier: float = 1.0
@export var damage_multiplier: float = 1.0

@export var physical_damage_pct: float = 0.0
@export var elementatl_damage_pct: float = 0.0
@export var fire_damage_pct: float = 0.0
@export var cold_damage_pct: float = 0.0
@export var lightning_damage_pct: float = 0.0
@export var chaos_damage_pct: float = 0.0
@export var holy_damage_pct: float = 0.0
@export var poison_damage_pct: float = 0.0

@export var armor_penetration_pct: float = 0.0
@export var fire_resist_penetration_pct: float = 0.0
@export var cold_resist_penetration_pct: float = 0.0
@export var lightning_resist_penetration_pct: float = 0.0
@export var chaos_resist_penetration_pct: float = 0.0

@export var life_leech_pct: float = 0.0
@export var mana_leech_pct: float = 0.0
@export var enery_shield_leech_pct: float = 0.0

# Damage over time properties
@export var applies_dot: bool = false
@export var dot_id: String = ""
@export var dot_tick_damage: float = 0.0
@export var dot_tick_interval: float = 1.0
@export var dot_duration: float = 0.0
@export var dot_max_stacks: int = 1
@export var dot_can_stack: bool = false

# Damage category flags
@export var is_attack: bool = false
@export var is_spell: bool = false
@export var is_area: bool = false
@export var is_projectile: bool = false

# Status Effects
@export var stun_chance_pct: float = 0.0
@export var freeze_chance_pct: float = 0.0
@export var chill_chance_pct: float = 0.0
@export var ignite_chance_pct: float = 0.0
@export var bleed_chance_pct: float = 0.0
@export var curse_chance_pct: float = 0.0
'''