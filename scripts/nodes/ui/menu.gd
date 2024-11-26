class_name Menu
extends Interface


signal opened
signal closed

@export var pause_game: bool = true
@export var show_mouse: bool = true
@export var use_background: bool = true
@export var base_window_size: Vector2 = Vector2(1152, 648)

@export_group("Animation")
@export var animations: Array[Animation]

var animation_player: AnimationPlayer = AnimationPlayer.new()
var animation_library: AnimationLibrary = AnimationLibrary.new()
var ui: UI


func _ready():
	ui = get_ui()
	
	animation_player.add_animation_library("", animation_library)
	add_child(animation_player)
	
	for animation in animations:
		var animation_name = animation.resource_path.get_file().get_basename()
		animation_library.add_animation(animation_name, animation)


func get_ui() -> Variant:
	var parent: Node = get_parent()
	var is_root: bool = false
	
	while not is_root:
		if parent is UI:
			return parent
		elif parent != get_tree().edited_scene_root:
			parent = parent.get_parent()
		else:
			is_root = true
	
	return null


func close(ignore_visibility: bool = false) -> void:
	if ui.active_menu == self:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		ui.hide_background()
		ui.active_menu = null
	
	visible = true if ignore_visibility else false
	closed.emit()


func open() -> void:
	if show_mouse:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if pause_game:
		get_tree().paused = true
	if use_background and ui.background:
		ui.show_background()
	
	ui.active_menu = self
	visible = true
	opened.emit()
