class_name BattleEntity
extends Node

signal progress_changed(progress: float)
signal attack_ready

@onready var health_component: Node = %HealthComponent

var combat_stats: CombatStats: set = set_combat_stats
var attack_interval_ticks: int = 0
var tick_counter: int = 0

func _init() -> void:
	# the node isn’t added to the scene tree, so connect in _init
	TickManager.connect("tick", _on_tick)

func set_combat_stats(stats: CombatStats) -> void:
	combat_stats = stats
	_recalculate_interval()
	tick_counter = 0
	emit_signal("progress_changed", 0.0)

func _recalculate_interval() -> void:
	if combat_stats and combat_stats.attack_speed > 0.0:
		# how many ticks must elapse between attacks
		attack_interval_ticks = int(ceil(TickManager.tick_rate / combat_stats.attack_speed))
	else:
		attack_interval_ticks = int(1e9) # effectively never

func _on_tick():
	if attack_interval_ticks <= 0:
		return

	tick_counter += 1
	var progress: float = float(tick_counter) / float(attack_interval_ticks)
	if progress > 1.0:
		progress = 1.0

	emit_signal("progress_changed", progress)

	if tick_counter >= attack_interval_ticks:
		tick_counter = 0
		emit_signal("attack_ready")
		# immediately reset the bar
		emit_signal("progress_changed", 0.0)
