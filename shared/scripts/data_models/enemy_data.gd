class_name EnemyData
extends Resource


@export var name: String = "Name Missing"
@export var texture: Texture2D

@export var base_attributes: AttributeData # old way but still dependencies in health component
@export var base_stats: StatBlock # new way
@export var equipped_skills: Array[SkillData]

@export var drop_table: ItemDropTable
