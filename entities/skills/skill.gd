class_name Skill
extends Resource


# Skill Base Stats
@export var base_dmg_min: float
@export var base_dmg_max: float
@export var base_speed: float

# Skill Type
enum types {attack, spell}
@export var type: types

# Visuals
#@export var animation = <reference the sprite frames here to later instatiate an animated sprite with it>