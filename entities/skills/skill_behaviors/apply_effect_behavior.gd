class_name ApplyEffectBehavior
extends SkillBehavior


@export var effects: Array[StatusEffect] = []


func execute(context: BattleContext, _skill: SkillData) -> void:
	if effects.is_empty():
		return

	if context.defender == null:
		return

	var status_effect_component = context.defender.status_effect_component
	if status_effect_component == null:
		return

	for effect in effects:
		status_effect_component.apply_effect(effect)
