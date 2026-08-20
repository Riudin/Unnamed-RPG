class_name CombatSummon
extends Node2D


@onready var sprite: Sprite2D = %Sprite2D
@onready var attack_component: AttackComponent = %AttackComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var status_effect_component: StatusEffectComponent = %StatusEffectComponent
@onready var resource_bars: VBoxContainer = %ResourceBars
@onready var enemy_name: Label = %Name
@onready var enemy_level: Label = %Level
@onready var name_display: HBoxContainer = %NameDisplay
@onready var status_effect_display: VBoxContainer = %StatusEffectDisplay


var enemy_data: EnemyData = null


func _ready() -> void:
	assert(enemy_data != null, "No EnemyData set for " + str(self))
	if not enemy_data.stats:
		print("EnemyData has no stats. Using default stats")
		enemy_data.stats = Stats.new()
	enemy_data._apply_level_scaling()
	
	# Giving the attacks a bit variety so they dont all land at the same time
	for skill in enemy_data.equipped_skills.size():
		enemy_data.equipped_skills[skill].base_speed *= randf_range(0.8, 1.2)
	
	attack_component.parent_data = enemy_data
	health_component.parent_data = enemy_data

	sprite.texture = enemy_data.texture
	enemy_name.text = str(enemy_data.name)
	enemy_level.text = str(enemy_data.level)
	if enemy_data.type == EnemyData.EnemyType.BOSS:
		_scale_boss_visuals()
	
	# these signal are currently only for updating the ui icons
	status_effect_component.effect_applied.connect(status_effect_display.on_effect_applied)
	status_effect_component.effect_updated.connect(status_effect_display.on_effect_updated)
	status_effect_component.effect_removed.connect(status_effect_display.on_effect_removed)


func _scale_boss_visuals() -> void:
	sprite.scale *= 2
	sprite.position.y *= 2
	resource_bars.position.y = sprite.position.y
	name_display.position.y += resource_bars.position.y


func on_visual_hit():
	health_component.on_visual_hit()
