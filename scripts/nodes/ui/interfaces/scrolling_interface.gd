class_name ScrollingInterface
extends Interface

## An [Interface] that scrolls either horizontally and vertically.


const SCROLL_STEPS: int = 20  ## The number of iterations before the exponential decay function (used for smoothing) stops.

@export var scroll_root: Interface  ## The actual node that is moved. Any other nodes that need to move should be [Anchor]ed to [member scroll_root]. If unassigned, the first Interface child will be used.
@export_range(0, 1, 1) var scroll_axis: int = 1  ## Controls which axis the ScrollingInterface is moved on. 0 is the x-axis (horizontal) and 1 is the y-axis (vertical).
@export var scroll_amount: float = 1  ## The distance (as a percent of the screen size) that [member scroll_root] is moved on each input.
@export var scroll_speed: float = 1  ## The speed input for the exponential decay function. Higher values will result in less smoothing.

var _current_step: int  # The current iteration of the exponential decay function. See [constant SCROLL_STEPS] for more details.
var _scroll_destination: float  # The current y position that [member scroll_root] is being moved towards. 
var _scroll_direction: int  # The direction of input (+1 or -1 / scroll up or scroll down).


func _ready():
	if scroll_root: return
	scroll_root = filter_children(ChildFilter.INTERFACE).front()


func _input(event):
	# Determine the position that scroll_root will be moved towards.
	if not (event.is_action_pressed("cycleUp") or event.is_action_pressed("cycleDown")): return
	_scroll_direction = int(event.is_action_pressed("cycleUp")) - int(event.is_action_pressed("cycleDown"))
	_scroll_destination = scroll_root.anchor_offset[scroll_axis] + _scroll_direction * scroll_amount / 100
	_current_step = SCROLL_STEPS


func _process(delta):
	if _current_step == 0: return
	_current_step -= 1
	
	scroll_root.anchor_offset[scroll_axis] = Math.exp_decay(scroll_root.anchor_offset[scroll_axis], _scroll_destination, scroll_speed, delta)
	manager.update()


## Resets the [member scroll_root]'s position to it's default.
func reset() -> void:
	scroll_root.anchor_offset[scroll_axis] = 0
	manager.update()
