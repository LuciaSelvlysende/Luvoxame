class_name Menu
extends Interface

## Handles opening and closing branches of [Interface]s.
##
## Part of the functionality for opening and closing Menus is handled by [UIScript_Lvx]. It might be
## a good idea to rearrange that in the future.


signal opened
signal closed

@export var close_destination: Menu
@export var pause_game: bool = true
@export var show_mouse: bool = true
@export var use_background: bool = true

@export_group("Animation")
@export var open_animation: StringName
@export var close_animation: StringName
@export var reset_animation: StringName
@export var animations: Array[Animation]

var _animation_player: AnimationPlayer = AnimationPlayer.new()
var _animation_library: AnimationLibrary = AnimationLibrary.new()


# Add animations.
func _ready():
	_animation_player.add_animation_library("", _animation_library)
	add_child(_animation_player)
	
	for animation in animations:
		var animation_name = animation.resource_path.get_file().get_basename()
		_animation_library.add_animation(animation_name, animation)


## Visually closes the menu. More functionality may be desired.
func close() -> void:
	if close_animation and reset_animation:
		_animation_player.play(close_animation)
		_animation_player.queue(reset_animation)
	
	visible = true if close_animation and reset_animation else false
	closed.emit()


## Visually opens the menu. More functionality may be desired.
func open() -> void:
	if open_animation:
		_animation_player.play(open_animation)
	
	visible = true
	opened.emit()
