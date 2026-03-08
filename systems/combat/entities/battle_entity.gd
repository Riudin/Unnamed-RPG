class_name BattleEntity
extends Node


@onready var health_component: HealthComponent = %HealthComponent
@onready var attack_component: AttackComponent = %AttackComponent

var attribute_data: AttributeData = null
var damage_data: DamageData
# var active_skill: Skill = null

var attack_speed: float = 1.0 # Placeholder


func _ready() -> void:
	health_component.connect("died", _on_death)

	# attack_speed = active_skill.base_speed * attribute_data.increased_attack_speed


# func calculate_damage_info() -> Dictionary:
# 	# This is not at the right place. Move to own function?
# 	var damage: float = randf_range(active_skill.base_dmg_min, active_skill.base_dmg_max)
# 	damage *= attribute_data.increased_dmg
# 	# here we can implement "more" dmg later

# 	var damage_info: Dictionary = {
# 		"damage": damage,
# 		"type": active_skill.type,
# 		"dot": false # unused
# 	}

# 	return damage_info


func _on_death():
	print(self.name, "died")
	queue_free()
