extends Panel


@onready var max_health_label: Label = %MaxHealthLabel


func _ready() -> void:
	update_labels()
	await get_tree().process_frame # Wait one frame for player to initialize
	
	# Listen directly to the player's stats for recalculations
	if GameState.player_data and GameState.player_data.stats:
		GameState.player_data.stats.stats_recalculated.connect(update_labels)
	else:
		push_warning("Stats display: Player stats not initialized yet")


func update_labels():
	if not GameState.player_data or not GameState.player_data.stats:
		return
	max_health_label.text = "Maximum Health: %.2f" % GameState.player_data.stats.current_max_health
