extends HBoxContainer

@export var slot_scene: PackedScene

@export var length: int = 5

var slotted_skills: Dictionary[int, SkillData] = {}

#signal skills_changed(new_skills)


func _ready():
# 	if not slot_scene:
# 		push_error("No Skillbar Slot Scene assigned!")
# 		return
# 	for i in length:
# 		var slot = slot_scene.instantiate()
# 		add_child(slot)
# 		# slot.slot_id = i
# 		slot.skill_changed.connect(_on_slot_skill_changed)
# 		slotted_skills.get_or_add(i, null)
	SignalBus.skills_changed.emit(slotted_skills)


# func _on_slot_skill_changed(slot_id, skill):
# 	slotted_skills[slot_id] = skill

# 	SignalBus.skills_changed.emit(slotted_skills)
