class_name Menu
extends Interface

## Handles opening and closing branches of [Interface]s.


signal opened  ## Emitted when the menu is opened.
signal closed  ## Emitted when the menu is closed.

@export var close_destination: Menu  ## The [Menu] that is opened when this menu is closed.
@export var pause_game: bool = true  ## When [code]true[/code], pauses the game while the menu is open.
@export var show_mouse: bool = true  ## When [code]true[/code], reveals the mouse cursor while the menu is open.
@export var use_background: bool = true  ## When [code]true[/code], shows the default menu background while the menu is open.

@export_group("Animation")
@export var open_animation: StringName  ## The name of the animation that should be played when the menu opens.
@export var close_animation: StringName  ## The name of the animation that should be played when the menu closes.
@export var reset_animation: StringName  ## The name of the animation that should be played immedietly after [member close_animation], resetting the menu to it's default state.
@export var animations: Array[Animation]  ## Holds animations used by the menu, inlcuding those specified by [member open_animation], [member close_animation], [member reset_animation].

var _animation_player: AnimationPlayer = AnimationPlayer.new()  # The animation player used to play animations for this menu.
var _animation_library: AnimationLibrary = AnimationLibrary.new()  # The animation library used to store animations for this menu.


# Add animations.
func _ready():
	_animation_player.add_animation_library("", _animation_library)
	add_child(_animation_player)
	
	for animation in animations:
		var animation_name = animation.resource_path.get_file().get_basename()
		_animation_library.add_animation(animation_name, animation)


## Visually closes the menu.
func close() -> void:
	manager.clear_active(self)
	
	if close_animation and reset_animation:
		_animation_player.play(close_animation)
		_animation_player.queue(reset_animation)
	
	visible = true if close_animation and reset_animation else false
	closed.emit()


## Visually opens the menu.
func open() -> void:
	manager.set_active(self)
	
	if open_animation:
		_animation_player.play(open_animation)
	
	visible = true
	opened.emit()
