class_name BattleUI
extends CanvasLayer


const INFO_PANEL_SCENE: PackedScene = preload("uid://hsv323wup8qh")

@onready var enemy_panel_container: Control = %EnemyInfoPanels
@onready var summons_panel_container: Control = %SummonsInfoPanels
@onready var ownership_line_container: Node2D = %OwnershipLineContainer

var enemy_panels: Array[InfoPanel] = []
var summon_panels: Array[InfoPanel] = []


func display_enemy_info(enemy: CombatEnemy) -> void:
	var new_panel := INFO_PANEL_SCENE.instantiate()
	enemy_panel_container.add_child(new_panel)
	# Base Data
	new_panel.associated_entity = enemy
	new_panel.enemy_name = enemy.enemy_data.name
	new_panel.entity_y_position = enemy.global_position.y
	new_panel.icon.texture = enemy.enemy_data.icon
	# Health
	new_panel.max_health = enemy.health_component.max_health
	enemy.health_component.health_changed.connect(new_panel._on_health_changed)
	# Status Effects
	enemy.status_effect_component.effect_applied.connect(new_panel.status_effect_display.on_effect_applied)
	enemy.status_effect_component.effect_updated.connect(new_panel.status_effect_display.on_effect_updated)
	enemy.status_effect_component.effect_removed.connect(new_panel.status_effect_display.on_effect_removed)
	# Skills
	enemy.attack_component.active_skill_changed.connect(new_panel.combat_skill_bar._on_active_skill_changed)
	enemy.attack_component.attack_progress_changed.connect(new_panel.combat_skill_bar._on_attack_progress_changed)

	enemy_panels.append(new_panel)
	call_deferred("_register_ownership_line", enemy, new_panel)


func display_summon_info(summon: CombatSummon) -> void:
	var new_panel := INFO_PANEL_SCENE.instantiate()
	summons_panel_container.add_child(new_panel)
	# Base Data
	new_panel.associated_entity = summon
	new_panel.enemy_name = summon.enemy_data.name
	new_panel.entity_y_position = summon.global_position.y
	new_panel.icon.texture = summon.enemy_data.icon
	# Health
	new_panel.max_health = summon.health_component.max_health
	summon.health_component.health_changed.connect(new_panel._on_health_changed)
	# Status Effects
	summon.status_effect_component.effect_applied.connect(new_panel.status_effect_display.on_effect_applied)
	summon.status_effect_component.effect_updated.connect(new_panel.status_effect_display.on_effect_updated)
	summon.status_effect_component.effect_removed.connect(new_panel.status_effect_display.on_effect_removed)
	# Skills
	summon.attack_component.active_skill_changed.connect(new_panel.combat_skill_bar._on_active_skill_changed)
	summon.attack_component.attack_progress_changed.connect(new_panel.combat_skill_bar._on_attack_progress_changed)

	summon_panels.append(new_panel)
	call_deferred("_register_ownership_line", summon, new_panel)


func _register_ownership_line(entity: Node2D, panel: InfoPanel) -> void: # TODO: entity as Node2D is not nice. I should capture CombatSummon and CombatEnemy but maybe we need a super class in the future
	if not is_instance_valid(panel) or not is_instance_valid(entity):
		return

	if entity.health_component and not entity.health_component.died.is_connected(_on_enemy_died_for_line):
		entity.health_component.died.connect(_on_enemy_died_for_line)
	# if not entity.tree_exited.is_connected(_on_enemy_died_for_line):
	# 	entity.tree_exited.connect(_on_enemy_died_for_line.bind(entity))

	var target := Marker2D.new()
	target.name = "OwnershipTarget"
	ownership_line_container.get_parent().add_child(target)
	target.global_position = panel.line_anchor.global_position

	if entity is CombatSummon:
		var panel_width = panel.get_rect().size.x
		target.global_position.x += panel_width + 4 # the position is 2 pixels to the left of the panel, so +4 to get it 2 pixels to the right

	ownership_line_container.ownership_lines.append({"entity": entity, "target": target, "panel": panel})
	ownership_line_container.queue_redraw()


func refresh_ownership_lines() -> void:
	# Control containers apply their new child positions at the end of the frame.
	await get_tree().process_frame

	for entry in ownership_line_container.ownership_lines:
		var target: Node2D = entry.get("target")
		if is_instance_valid(target):
			target.queue_free()

	ownership_line_container.ownership_lines.clear()

	var all_panels: Array[InfoPanel] = []
	all_panels.append_array(enemy_panels)
	all_panels.append_array(summon_panels)

	for panel in all_panels:
		if not is_instance_valid(panel):
			continue

		var entity: Node2D = panel.associated_entity
		if not is_instance_valid(entity):
			continue

		_register_ownership_line(entity, panel)

	ownership_line_container.queue_redraw()


# clunky name but this should delete the ownership line if an entity dies
func _on_enemy_died_for_line(entity: Node2D) -> void:
	for i in range(ownership_line_container.ownership_lines.size() - 1, -1, -1):
		var entry = ownership_line_container.ownership_lines[i]
		if entry.get("entity") == entity:
			var target: Node2D = entry.get("target")
			if is_instance_valid(target):
				target.queue_free()
			ownership_line_container.ownership_lines.remove_at(i)

	ownership_line_container.queue_redraw()

	if entity is CombatSummon:
		_remove_panel(entity)


func sort_enemy_panels() -> void:
	var sorted_panels: Array[InfoPanel] = []
	for panel in enemy_panels:
		if is_instance_valid(panel):
			sorted_panels.append(panel)

	sorted_panels.sort_custom(func(a: InfoPanel, b: InfoPanel):
		return a.entity_y_position < b.entity_y_position
	)

	for index in range(sorted_panels.size()):
		var panel: InfoPanel = sorted_panels[index]
		if enemy_panel_container.get_children().has(panel):
			enemy_panel_container.move_child(panel, index)

	call_deferred("refresh_ownership_lines")


func sort_summon_panels() -> void:
	var sorted_panels: Array[InfoPanel] = []
	for panel in summon_panels:
		if is_instance_valid(panel):
			sorted_panels.append(panel)

	sorted_panels.sort_custom(func(a: InfoPanel, b: InfoPanel):
		return a.entity_y_position < b.entity_y_position
	)

	for index in range(sorted_panels.size()):
		var panel: InfoPanel = sorted_panels[index]
		if summons_panel_container.get_children().has(panel):
			summons_panel_container.move_child(panel, index)

	call_deferred("refresh_ownership_lines")


func _remove_panel(entity) -> void:
	for i in range(ownership_line_container.ownership_lines.size() - 1, -1, -1):
		var entry = ownership_line_container.ownership_lines[i]
		if entry.get("entity") != entity:
			continue

		var target: Node2D = entry.get("target")
		if is_instance_valid(target):
			target.queue_free()
		ownership_line_container.ownership_lines.remove_at(i)

	for i in range(summon_panels.size() - 1, -1, -1):
		var panel := summon_panels[i]
		if panel.associated_entity != entity:
			continue

		summon_panels.remove_at(i)
		_fade_out_and_remove_panel(panel)

	ownership_line_container.queue_redraw()
	call_deferred("refresh_ownership_lines")


func _fade_out_and_remove_panel(panel: InfoPanel) -> void:
	await get_tree().create_timer(1.0).timeout
	if not is_instance_valid(panel):
		return

	var fade_tween := create_tween()
	fade_tween.tween_property(panel, "modulate:a", 0.0, 0.25)
	await fade_tween.finished
	if is_instance_valid(panel):
		panel.queue_free()
		call_deferred("refresh_ownership_lines")


func _on_pause_button_pressed() -> void:
	get_tree().paused = !get_tree().paused


func _on_half_speed_button_pressed() -> void:
	Engine.time_scale = 0.5


func _on_normal_speed_button_pressed() -> void:
	Engine.time_scale = 1.0


func _on_double_speed_button_pressed() -> void:
	Engine.time_scale = 2.0


func _on_5speed_button_pressed() -> void:
	Engine.time_scale = 5.0
