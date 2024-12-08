class_name TickClock
extends Timer

## Runs certain game processes at a specified rate and order.
##
## Each tick, certain processes are preformed, directed by the [member subticks] dictionary. Currently,
## only the player has processes that update once per tick, but this will be changed in Indev 1.3, with
## the addition of block updates. [br][br]
##
## Some of these per-tick processes involves storing information that is updated once per tick. This
## is handled by various "TickInformation" resources, such as [member player_tick_information].


@export_range(0, 100) var tick_speed: float:  ## Number of ticks per second. Certain game processes will run faster/slower at higher/lower ticks per second.
	set(value):
		wait_time = 1 / value
		if time_left > wait_time:
			stop()
			start()
		tick_speed = value

static var player_tick_information: PlayerTickInformation = PlayerTickInformation.new()  ## Stores information about the Player that updates once per tick.

## Dictionary that stores group names as keys and their corresponding method as values.
var subticks = {
	PlayerTick = "_on_player_tick",
}


func _on_tick():
	for subtick in subticks:
		get_tree().call_group(subtick, subticks[subtick])


## Stores information about the player that is updated once per tick.
class PlayerTickInformation:
	var transform: Transform3D  ## The [Transform3D] of the [Player].
	var raycast: Raycast  ## The last raycast preformed, updated each player tick.
	var current_block: StringName = "dirt" ## The id of the currently selected [Block].
	var current_variant: StringName = "dirt_full"  ## The id of the currently selected [BlockVariant].
	var current_voxel: int = 1 ## The id of the currently selected voxel.
