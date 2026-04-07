extends Node


var skills: Array[SkillData] = []


func _ready() -> void:
	pass
	#get_skills_from_folder("res://entities/skills/skill_resources/")


func get_skills_from_folder(folder_path):
	for file_name in DirAccess.get_files_at(folder_path):
		if (file_name.get_extension() == "tres"):
			skills.append(load(folder_path + file_name))