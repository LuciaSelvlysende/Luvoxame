class_name TickClock
extends Timer

## Runs certain game processes at a specified rate and order.


@export var tick_speed: float  ## Number of ticks per second. Certain game processes will run faster/slower at higher/lower ticks per second.

static var player_tick_information: PlayerTickInformation = PlayerTickInformation.new()  ## Stores information about the Player that updates once per tick.

## Dictionary that stores group names as keys and their corresponding method as values.
var subticks = {
	PlayerTick = "_on_player_tick",
}


func _ready():
	wait_time = 1 / tick_speed


func _on_tick():
	for subtick in subticks:
		get_tree().call_group(subtick, subticks[subtick])
