class_name ScrollingInterface
extends Interface


const SCROLL_STEPS: int = 20

@export var scroll_root: Interface
@export var scroll_amount: float = 1
@export var scroll_speed: float = 1

var scroll_destination: float
var scroll_direction: int
var current_step: int


func _ready():
	scroll_root = scroll_root if scroll_root else filter_children(Interface.ChildFilter.INTERFACE).front()


func _input(event):
	if not (event.is_action_pressed("cycleUp") or event.is_action_pressed("cycleDown")): return
	
	scroll_direction = int(event.is_action_pressed("cycleUp")) - int(event.is_action_pressed("cycleDown"))
	scroll_destination = scroll_root.anchor_offset.y + scroll_direction * scroll_amount / 100
	current_step = SCROLL_STEPS


func _process(delta):
	if current_step == 0: return
	current_step -= 1
	
	scroll_root.anchor_offset.y = Math.exp_decay(scroll_root.anchor_offset.y, scroll_destination, scroll_speed, delta)
	manager.update()


func reset() -> void:
	scroll_root.anchor_offset.y = 0
	if manager:
		manager.update()
