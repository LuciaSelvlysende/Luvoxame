class_name UI
extends CanvasLayer


@export var background: Node

var active_menu: Node


func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if event.is_action_pressed("escape"):
		if active_menu:
			active_menu.close()
		else:
			%PauseMenu.open()


func show_background() -> void:
	background.visible = true
	var tween: Tween = create_tween()
	tween.tween_property(background, "self_modulate", Color.WHITE, 0.2)


func hide_background() -> void:
	background.visible = true
	var tween: Tween = create_tween()
	tween.tween_property(background, "self_modulate", Color.TRANSPARENT, 0.2)
	await tween.finished
	background.visible = false
