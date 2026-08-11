### Singleton ###
extends Node


### UI Input Signals
# Sent by interaction_component | Received by ui_manager
@warning_ignore("unused_signal") signal enemy_clicked(enemy)
# Sent by forest_area_screen | Received by ui_manager
@warning_ignore("unused_signal") signal dungeon_clicked(dungeon_data)
# Sent by level | Received by ui_manager
@warning_ignore("unused_signal") signal forest_area_entry_requested()

### Combat Signals
# Sent by  | Received by 
@warning_ignore("unused_signal") signal battle_started(enemy)
# Sent by  | Received by 
@warning_ignore("unused_signal") signal leveled_up(new_level, levels_gained, skill_points_awarded)
# Sent by  | Received by 
@warning_ignore("unused_signal") signal xp_changed(current_xp, xp_to_next)
# Sent by battle_manager | Received by dungeon_run
@warning_ignore("unused_signal") signal battle_won()
# Sent by battle_manager | Received by dungeon_run
@warning_ignore("unused_signal") signal dungeon_boss_defeated()
# Sent by battle_manager | Received by dungeon_run
@warning_ignore("unused_signal") signal dungeon_failed()

### Dungeon Run Signals
# Sent by dungeon_map | Received by dungeon_run
@warning_ignore("unused_signal") signal dungeon_map_exited(room: Room)
# Sent by campfire_room | Received by dungeon_run
@warning_ignore("unused_signal") signal campfire_room_exited()
# Sent by shrine_room | Received by dungeon_run
@warning_ignore("unused_signal") signal shrine_room_exited()
# Sent by battle_reward_screen | Received by dungeon_run
@warning_ignore("unused_signal") signal battle_reward_exited()
# Sent by dungeon_reward_screen | Received by dungeon_run
@warning_ignore("unused_signal") signal dungeon_reward_exited()
