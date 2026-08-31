extends HBoxContainer


@onready var skill_icon_1: TextureRect = %SkillIcon1
@onready var skill_icon_2: TextureRect = %SkillIcon2
@onready var attack_progress: TextureProgressBar = %AttackProgress


func _ready() -> void:
	attack_progress.show() # its set to hide in the editor for visual clarity
	attack_progress.value = 0.0


func _on_active_skill_changed(current_skill: SkillData, next_skill: SkillData) -> void:
	skill_icon_1.texture = current_skill.skill_icon
	skill_icon_2.texture = next_skill.skill_icon


func _on_attack_progress_changed(progress: float) -> void:
	attack_progress.value = progress
