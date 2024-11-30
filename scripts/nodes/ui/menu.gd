class_name Menu
extends Interface


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

var animation_player: AnimationPlayer = AnimationPlayer.new()
var animation_library: AnimationLibrary = AnimationLibrary.new()


func _ready():
	animation_player.add_animation_library("", animation_library)
	add_child(animation_player)
	
	for animation in animations:
		var animation_name = animation.resource_path.get_file().get_basename()
		animation_library.add_animation(animation_name, animation)


func close() -> void:
	if close_animation and reset_animation:
		animation_player.play(close_animation)
		animation_player.queue(reset_animation)
	
	visible = true if close_animation and reset_animation else false
	closed.emit()


func open() -> void:
	if open_animation:
		animation_player.play(open_animation)
	
	visible = true
	opened.emit()
