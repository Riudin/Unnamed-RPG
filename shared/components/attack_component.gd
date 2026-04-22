class_name AttackComponent
extends Node


#signal progress_changed(progress: float)

var attack_interval_ticks: int = 0
var tick_counter: int = 0

@export var skill_bar_highlight: PackedScene
var active_highlight: Control = null

@onready var parent = get_parent()
@onready var attack_bar: TextureProgressBar = %AttackBar
@onready var skill_bar: Control = %CombatSkillBar
@onready var windup_anim_sprite: AnimatedSprite2D = %WindupAnimation

var skill_bar_icons: Array[TextureRect] = []

var parent_data: Resource = null # player_data or enemy_data

var target: Node

@export var base_damage_sources: Array[DamageSource]
#@export var base_stats: StatBlock = null

var skill_index := 0
#var skills: Dictionary[int, SkillData] = {}
var skills: Array[SkillData]: set = set_skills

# @export var damages: Array[DamageSource] = []
# @export var default_damage: DamageSource


func _ready() -> void:
	await get_parent().ready
	TickManager.connect("tick", _on_tick)
	#SignalBus.skills_changed.connect(set_skills)

	assert(parent_data != null and parent_data.equipped_skills, "No Parent Data assigned, or parent has no Data with equipped_skills!")
	set_skills(parent_data.equipped_skills)
	setup_skill_bar()
	
	# Wait for layout engine to compute positions of newly added skill bar icons
	await get_tree().process_frame
	set_skill_bar_highlight()
	play_windup_animation()

	if attack_bar:
		attack_bar.value = 0.0
		attack_bar.visible = true # for visual clarity it's set to false in the editor


func set_skills(new_skills: Array[SkillData]):
	skills = new_skills
	skill_index = 0

	# make sure skill index references the first equipped skill
	for i in skills.size():
		if skills[skill_index] == null:
			skill_index = (skill_index + 1) % skills.size()
		
	# if no skill is equipped TODO: use default attack
	if skills[skill_index] == null:
		#print("no skill equipped")
		_calculate_attack_interval(0.0) # TODO: replace with default attack
	else:
		_calculate_attack_interval(skills[skill_index].base_speed)


func setup_skill_bar():
	if skill_bar and skills[skill_index] != null:
		for skill in skills.size():
			if skills[skill] == null:
				skill_bar_icons.append(null)
				continue

			var icon = TextureRect.new()
			icon.texture = skills[skill].skill_icon
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			skill_bar_icons.append(icon)
			skill_bar.add_child(icon)


func _calculate_attack_interval(skill_speed: float) -> void:
	if skill_speed > 0.0:
		# how many ticks must elapse between attacks
		attack_interval_ticks = int(ceil(TickManager.TICK_RATE / skill_speed)) # Note that ceil introduces breakpoints.
		# for example attackspeed of 6.7 and 7.4 both return 9 attack_interval_ticks. You'd need 7.5 attackspeed to get 8 attack_interval_ticks.
		# This is not clean because speed should be == attacks per second. Regardless this system is needed right now to make use of the ticks for deterministic timing
	else:
		attack_interval_ticks = int(1e9) # effectively never
	
	tick_counter = 0

	if attack_bar:
		attack_bar.value = 0.0


func _on_tick():
	if attack_interval_ticks <= 0: return

	# this check also makes sure we execute nothing on tick, when there is no battle happening
	if target == null:
		return

	tick_counter += 1

	# Calculate Progress
	var progress: float = float(tick_counter) / float(attack_interval_ticks)
	progress = clamp(progress, 0.0, 1.0)

	if attack_bar:
		attack_bar.value = progress

	# Attack
	if tick_counter >= attack_interval_ticks:
		tick_counter = 0
		
		trigger_attack()

		if attack_bar:
			attack_bar.value = 0.0


func trigger_attack() -> void:
	var skill = skills[skill_index]

	# if there is no skill, we don't attack. this shouldn't happen normally
	if skill == null:
		return

	# apply skill modifiers
	if skill and not skill.inherent_mods.is_empty():
		for mod in skill.inherent_mods:
			parent_data.stats.add_modifier(mod)
		# recalculate directly to ensure stats are ready
		parent_data.stats.recalculate_stats()

	#print(parent, " triggering Skill: ", skill.skill_name)

	var context = BattleContext.new()
	context.attacker = parent
	context.defender = target
	context.attacker_stats = parent_data.stats

	await skill.execute(context)

	# remove skill modifiers and recalculate stats again
	if skill and not skill.inherent_mods.is_empty():
		for mod in skill.inherent_mods:
			parent_data.stats.remove_modifier(mod)
		parent_data.stats.recalculate_stats()

	# rotate to next skill and loop back to beginning
	skill_index = (skill_index + 1) % skills.size()

	# rotate over empty slots
	while skills[skill_index] == null:
		skill_index = (skill_index + 1) % skills.size()

	_calculate_attack_interval(skills[skill_index].base_speed)
	
	set_skill_bar_highlight()
	play_windup_animation()


func set_skill_bar_highlight():
	if active_highlight != null:
		active_highlight.queue_free()
		#active_highlight = null

	if skill_bar_highlight:
		var highlight := skill_bar_highlight.instantiate()
		skill_bar_icons[skill_index].add_child(highlight)
		active_highlight = highlight

	attack_bar.global_position = skill_bar_icons[skill_index].global_position
	attack_bar.position.y += 2.0


func play_windup_animation():
	if windup_anim_sprite:
		var cast_time = attack_interval_ticks / TickManager.TICK_RATE
		var animation = skills[skill_index].windup_animation_name

		var fps = windup_anim_sprite.sprite_frames.get_animation_speed(animation)
		var frame_count = windup_anim_sprite.sprite_frames.get_frame_count(animation)
		var base_duration = frame_count / fps

		if cast_time <= 0:
			return

		windup_anim_sprite.speed_scale = base_duration / cast_time
		
		windup_anim_sprite.stop()
		windup_anim_sprite.play(animation)
