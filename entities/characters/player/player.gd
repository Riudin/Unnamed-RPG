class_name Player
extends CharacterBody2D


@export var base_attribute_data: AttributeData
@export var attribute_data: AttributeData
@export var damage_data: DamageData

@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var input_component: InputComponent = %InputComponent
@onready var navigation_component: NavigationComponent = %NavigationComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var leveling_component: LevelingComponent = %LevelingComponent
@onready var equipment_component: EquipmentComponent = %EquipmentComponent

@onready var sprite: Sprite2D = %Sprite2D


func _ready() -> void:
	input_component.connect("movement_input", _on_movement_input)
	navigation_component.connect("navigating_to_target", _on_navigating_to_target)
	navigation_component.connect("navigation_finished", _on_navigation_finished)


func _physics_process(delta: float) -> void:
	print("Fire res: ", attribute_data.fire_resist_pct)
	print("Cold res: ", attribute_data.cold_resist_pct)
	print("Lightning res: ", attribute_data.lightning_resist_pct)


func _on_movement_input(target):
	navigation_component.navigate_to_target(target)


func _on_navigating_to_target(direction):
	movement_component.move_toward(direction)
	animation_component.play_animation("walk")


func _on_navigation_finished():
	animation_component.play_animation("idle")


### Equipment Stuff --- maybe put this in a stats_component or something later on
func _has_stat(stat_name: String) -> bool:
	for p in attribute_data.get_property_list():
		if p.name == stat_name:
			return true
	return false


func recalculate_stats():
	attribute_data = base_attribute_data.duplicate(true)

	if equipment_component:
		for item in equipment_component.get_all_items():
			if item == null:
				continue
			
			for stat_name in item.rolled_stats.keys():
				if _has_stat(stat_name):
					attribute_data.set(
						stat_name,
						attribute_data.get(stat_name) + item.rolled_stats[stat_name]
					)
				else:
					push_warning("Unknown stat: %s" % stat_name)


func equip_item(item: ItemInstance):
	if equipment_component:
		equipment_component.equip(item)
		recalculate_stats()


func unequip_item(slot: LootEnums.ItemType):
	if equipment_component:
		equipment_component.unequip(slot)
		recalculate_stats()