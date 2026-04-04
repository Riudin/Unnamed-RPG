class_name SkillSlot
extends Control


@export var skill: SkillData

@onready var skill_icon: TextureRect = %SkillIcon


# func _ready() -> void:
# 	if not skill:
# 		print("No skill found")

# 	skill_icon.texture = skill.skill_icon
