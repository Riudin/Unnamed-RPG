class_name SingleHitBehavior
extends SkillBehavior


signal hit(source, target)


func execute(source, target):
	hit.emit(source, target)
