class_name StatusEffectInstance
extends RefCounted


var effect: StatusEffect
var remaining_ticks: int
var tick_accumulator: int = 0
var stacks: int = 1
var source = null
var stats_snapshot: Stats = null
