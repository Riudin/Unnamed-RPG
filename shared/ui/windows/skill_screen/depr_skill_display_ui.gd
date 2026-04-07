class_name SkillDisplayUI
extends GridContainer


@export var slot_scene: PackedScene


func _ready() -> void:
	for skill in SkillRegistry.skills:
		var slot = slot_scene.instantiate()
		slot.skill = skill
		add_child(slot)
		slot.skill_icon.texture = skill.skill_icon
