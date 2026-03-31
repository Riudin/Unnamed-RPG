class_name AttackComponent
extends Node


signal progress_changed(progress: float)

var attack_interval_ticks: int = 0
var tick_counter: int = 0

@onready var parent = get_parent()
var target: Node

@export var base_damage_sources: Array[DamageSource]
@export var base_stats: StatBlock

var skill_index := 0
@export var skills: Array[SkillData] # TODO: this should not be an export. just for debugging

# @export var damages: Array[DamageSource] = []
# @export var default_damage: DamageSource


func _ready() -> void:
	await get_parent().ready
	TickManager.connect("tick", _on_tick)
	_calculate_attack_interval(skills[skill_index].base_speed)


func _calculate_attack_interval(skill_speed: float) -> void:
	if skill_speed > 0.0:
		# how many ticks must elapse between attacks
		attack_interval_ticks = int(ceil(TickManager.TICK_RATE / skill_speed)) # Note that ceil introduces breakpoints.
		# for example attackspeed of 6.7 and 7.4 both return 9 attack_interval_ticks. You'd need 7.5 attackspeed to get 8 attack_interval_ticks.
		# This is not clean because speed should be == attacks per second. Regardless this system is needed right now to make use of the ticks for deterministic timing
	else:
		attack_interval_ticks = int(1e9) # effectively never
	
	tick_counter = 0
	emit_signal("progress_changed", 0.0)


# func set_damages(list):
# 	damages.clear()

# 	if list == null:
# 		damages = [default_damage]
# 		return

# 	for d in list:
# 		damages.append(d.duplicate(true))


func _on_tick():
	if attack_interval_ticks <= 0: return

	# this check also makes sure we execute nothing on tick, when there is no battle happening
	if target == null:
		return

	tick_counter += 1

	# Calculate Progress
	var progress: float = float(tick_counter) / float(attack_interval_ticks)
	progress = clamp(progress, 0.0, 1.0)

	emit_signal("progress_changed", progress)

	# Attack
	if tick_counter >= attack_interval_ticks:
		tick_counter = 0
		
		trigger_attack()

		emit_signal("progress_changed", 0.0)


func trigger_attack():
	var skill = skills[skill_index]

	if skill == null:
		return

	print(parent, " triggering Skill: ", skill.skill_name)

	var context = BattleContext.new()
	context.attacker = parent
	context.defender = target
	context.base_sources = base_damage_sources
	context.base_stats = base_stats

	skill.execute(context)

	# rotate to next skill and loop back to beginning
	skill_index = (skill_index + 1) % skills.size()

	_calculate_attack_interval(skills[skill_index].base_speed)
