class_name DamageInstance
extends RefCounted

### Instantiated by BattleContext when a skill that does damage is triggered. This Instance's data is then sent to DamageSystem to calculate damage.


var sources: Array[DamageSource] = []
var stats: StatBlock
var attacker
var defender