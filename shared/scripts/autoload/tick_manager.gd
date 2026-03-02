extends Node

### Using ticks for the game makes sure that we get exactly the tick signals every second that are defined in tick_rate.
### This differs from just using delta in that tick dependent actions will always run at the same speed, regardless of
### framerate. Using delta would mean we correct values depending on framerate but using ticks does the corrections before sending
### the signals. This ensures synchronism for multiplayer and complex, time-dependant systems like automatic combat in this case.


signal tick

var tick_rate: float = 60.0
var accumulator: float = 0.0


func _process(delta: float) -> void:
	accumulator += delta
	while accumulator >= 1.0 / tick_rate:
		accumulator -= 1.0 / tick_rate
		tick.emit()
