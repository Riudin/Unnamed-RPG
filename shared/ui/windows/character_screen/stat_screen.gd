class_name StatScreen
extends Panel

@onready var offence_stats: ScrollContainer = %OffenceStats
@onready var defence_stats: ScrollContainer = %DefenceStats
@onready var misc_stats: ScrollContainer = %MiscStats

# Offence
@onready var dps_label: Label = %DPSLabel
@onready var attacks_per_second_label: Label = %AttacksPerSecondLabel
@onready var mh_attack_speed_mod_label: Label = %MHAttackSpeedModLabel
@onready var mh_combined_damage_label: Label = %MHCombinedDamageLabel
@onready var mh_physical_damage_label: Label = %MHPhysicalDamageLabel
@onready var mh_fire_damage_label: Label = %MHFireDamageLabel
@onready var mh_cold_damage_label: Label = %MHColdDamageLabel
@onready var mh_lightning_damage_label: Label = %MHLightningDamageLabel
@onready var mh_chaos_damage_label: Label = %MHChaosDamageLabel

# Defense
@onready var armor_label: Label = %ArmorLabel
@onready var physical_damage_reduction_label: Label = %PhysicalDamageReductionLabel
@onready var evasion_label: Label = %EvasionLabel
@onready var chance_to_evade_label: Label = %ChanceToEvadeLabel
@onready var life_regen_label: Label = %LifeRegenLabel
@onready var life_leech_label: Label = %LifeLeechLabel
@onready var energy_shield_regen_label: Label = %EnergyShieldRegenLabel
@onready var energy_shield_leech_label: Label = %EnergyShieldLeechLabel
@onready var mana_regen_label: Label = %ManaRegenLabel
@onready var mana_leech_label: Label = %ManaLeechLabel
@onready var fire_res_label: Label = %FireResLabel
@onready var cold_res_label: Label = %ColdResLabel
@onready var lightning_res_label: Label = %LightningResLabel
@onready var chaos_res_label: Label = %ChaosResLabel


func _ready() -> void:
	update_values()
	GameState.player_stats_changed.connect(_on_player_stats_changed)


func update_values():
	dps_label.text = ""
	attacks_per_second_label.text = ""
	mh_attack_speed_mod_label.text = ""
	mh_combined_damage_label.text = "%d - %d" % [GameState.player_data.stats.combined_damage, GameState.player_data.stats.combined_damage_range]
	mh_physical_damage_label.text = "%d - %d" % [GameState.player_data.stats.current_physical_damage, GameState.player_data.stats.current_physical_damage_range]
	mh_fire_damage_label.text = "%d - %d" % [GameState.player_data.stats.current_fire_damage, GameState.player_data.stats.current_fire_damage_range]
	mh_cold_damage_label.text = "%d - %d" % [GameState.player_data.stats.current_cold_damage, GameState.player_data.stats.current_cold_damage_range]
	mh_lightning_damage_label.text = "%d - %d" % [GameState.player_data.stats.current_lightning_damage, GameState.player_data.stats.current_lightning_damage_range]
	mh_chaos_damage_label.text = "%d - %d" % [GameState.player_data.stats.current_chaos_damage, GameState.player_data.stats.current_chaos_damage_range]

	armor_label.text = str(GameState.player_data.stats.current_armor)
	physical_damage_reduction_label.text = str(GameState.player_data.stats.current_physical_damage_reduction)
	evasion_label.text = str(GameState.player_data.stats.current_evasion)
	chance_to_evade_label.text = ""
	life_regen_label.text = str(GameState.player_data.stats.current_life_regen)
	life_leech_label.text = str(GameState.player_data.stats.current_life_leech)
	energy_shield_regen_label.text = str(GameState.player_data.stats.current_enery_shield_regen)
	energy_shield_leech_label.text = str(GameState.player_data.stats.current_enery_shield_leech)
	mana_regen_label.text = str(GameState.player_data.stats.current_mana_regen)
	mana_leech_label.text = str(GameState.player_data.stats.current_mana_leech)
	fire_res_label.text = str(GameState.player_data.stats.current_fire_resist)
	cold_res_label.text = str(GameState.player_data.stats.current_cold_resist)
	lightning_res_label.text = str(GameState.player_data.stats.current_lightning_resist)
	chaos_res_label.text = str(GameState.player_data.stats.current_chaos_resist)


func _on_player_stats_changed():
	update_values.call_deferred()


func _on_offence_stats_button_pressed() -> void:
	offence_stats.show()
	defence_stats.hide()
	misc_stats.hide()


func _on_defence_stats_button_pressed() -> void:
	offence_stats.hide()
	defence_stats.show()
	misc_stats.hide()


func _on_misc_stats_button_pressed() -> void:
	offence_stats.hide()
	defence_stats.hide()
	misc_stats.show()
