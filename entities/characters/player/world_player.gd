class_name Player
extends CharacterBody2D


@export var stats: Stats

@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var input_component: InputComponent = %InputComponent
@onready var navigation_component: NavigationComponent = %NavigationComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var equipment_component: EquipmentComponent = %EquipmentComponent

@onready var sprite: Sprite2D = %Sprite2D


func _ready() -> void:
	input_component.connect("movement_input", _on_movement_input)
	navigation_component.connect("navigating_to_target", _on_navigating_to_target)
	navigation_component.connect("navigation_finished", _on_navigation_finished)

	if not GameState.player_data.stats:
		GameState.player_data.stats = stats

	recalculate_skills()

# just for debugging
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		# Iterate over a copy to avoid modifying the array while iterating
		for m in GameState.player_data.stats.stat_modifiers.duplicate():
			GameState.player_data.stats.remove_modifier(m)
	
	if event.is_action_pressed("debug2"):
		var mod = StatModifier.new()
		mod.type = StatModifier.ModifierType.ADD
		mod.stat = Stats.ModifiableStats.MAX_HEALTH
		mod.min_amount = 10.0
		mod.max_amount = 20.0
		mod.amount = randf_range(mod.min_amount, mod.max_amount)
		GameState.player_data.stats.add_modifier(mod)


func _on_movement_input(target):
	navigation_component.navigate_to_target(target)


func _on_navigating_to_target(direction):
	movement_component.move_toward(direction)
	animation_component.play_animation("walk")


func _on_navigation_finished():
	animation_component.play_animation("idle")


### Equipment Stuff --- maybe put this in a stats_component or something later on
func recalculate_skills():
	GameState.player_data.equipped_skills = equipment_component.get_all_skills()


func equip_item(item: ItemInstance, slot_index: int = 0):
	if equipment_component:
		# Update equipped items data
		equipment_component.equip(item, slot_index)

		# Add new affixes to stats
		if not item.prefixes.is_empty(): # this should never happen atm because loot_generator is supposed to add a null value if htere is no other affix left. so this is double checking.
			for p in item.prefixes:
				if p == null or p.mods.is_empty():
					continue
				for m in p.mods:
					GameState.player_data.stats.add_modifier(m)
		
		if not item.suffixes.is_empty():
			for s in item.suffixes:
				if s == null or s.mods.is_empty():
					continue
				for m in s.mods:
					GameState.player_data.stats.add_modifier(m)

		GameState.player_data.stats.recalculate_stats()

		# Recalculate skills incase it was an item with a skill
		recalculate_skills()


func unequip_item(item: ItemInstance, slot: LootEnums.ItemType, slot_index: int = 0):
	if equipment_component:
		# Update equipped items data
		equipment_component.unequip(slot, slot_index)

		# Remove old affixes from stats
		if not item.prefixes.is_empty():
			for p in item.prefixes:
				if p == null or p.mods.is_empty():
					continue
				for m in p.mods:
					GameState.player_data.stats.remove_modifier(m)
		
		if not item.suffixes.is_empty():
			for s in item.suffixes:
				if s == null or s.mods.is_empty():
					continue
				for m in s.mods:
					GameState.player_data.stats.remove_modifier(m)
		
		GameState.player_data.stats.recalculate_stats()

		# Recalculate skills incase it was an item with a skill
		recalculate_skills()
