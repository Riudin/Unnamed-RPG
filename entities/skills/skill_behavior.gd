class_name SkillBehavior
extends Resource

### Super class of different behaviors. They define how a skill behaves when triggered, e.g. single hit, multi hit, apply effect, etc.


func execute(context: BattleContext, skill: SkillData, on_hit: Callable):
	push_error("execute() not implemented")