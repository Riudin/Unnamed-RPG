class_name BattleUI
extends CanvasLayer


const INFO_PANEL_SCENE: PackedScene = preload("uid://hsv323wup8qh")

@onready var enemy_info_panels: Control = %EnemyInfoPanels
@onready var ownership_line_container: Node2D = %OwnershipLineContainer


func display_enemy_info(enemy: CombatEnemy) -> void:
	var new_panel := INFO_PANEL_SCENE.instantiate()
	enemy_info_panels.add_child(new_panel)
	new_panel.enemy_name = enemy.enemy_data.name
	new_panel.max_health = enemy.health_component.max_health
	enemy.health_component.health_changed.connect(new_panel._on_health_changed)
	new_panel.icon.texture = enemy.enemy_data.icon
	enemy.status_effect_component.effect_applied.connect(new_panel.status_effect_display.on_effect_applied)
	enemy.status_effect_component.effect_updated.connect(new_panel.status_effect_display.on_effect_updated)
	enemy.status_effect_component.effect_removed.connect(new_panel.status_effect_display.on_effect_removed)
	enemy.attack_component.active_skill_changed.connect(new_panel.combat_skill_bar._on_active_skill_changed)
	enemy.attack_component.attack_progress_changed.connect(new_panel.combat_skill_bar._on_attack_progress_changed)

	call_deferred("_register_ownership_line", enemy, new_panel)


func _register_ownership_line(enemy: CombatEnemy, panel: InfoPanel) -> void:
	if not is_instance_valid(panel):
		return

	panel.died.connect(_on_panel_died)
	panel.tree_exited.connect(_on_panel_died.bind(panel))
	if is_instance_valid(enemy) and enemy.health_component:
		enemy.health_component.died.connect(_on_enemy_died_for_line)
	if is_instance_valid(enemy):
		enemy.tree_exited.connect(_on_enemy_died_for_line.bind(enemy))

	var target := Marker2D.new()
	target.name = "OwnershipTarget"
	ownership_line_container.get_parent().add_child(target)
	target.global_position = panel.line_anchor.global_position

	ownership_line_container.ownership_lines.append({"enemy": enemy, "target": target, "panel": panel})
	ownership_line_container.queue_redraw()


func _on_panel_died(panel: InfoPanel) -> void:
	for i in range(ownership_line_container.ownership_lines.size() - 1, -1, -1):
		var entry = ownership_line_container.ownership_lines[i]
		if entry.get("panel") == panel:
			var target: Node2D = entry.get("target")
			if is_instance_valid(target):
				target.queue_free()
			ownership_line_container.ownership_lines.remove_at(i)
			break

	ownership_line_container.queue_redraw()


func _on_enemy_died_for_line(enemy: CombatEnemy) -> void:
	for i in range(ownership_line_container.ownership_lines.size() - 1, -1, -1):
		var entry = ownership_line_container.ownership_lines[i]
		if entry.get("enemy") == enemy:
			var target: Node2D = entry.get("target")
			if is_instance_valid(target):
				target.queue_free()
			ownership_line_container.ownership_lines.remove_at(i)

	ownership_line_container.queue_redraw()


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
