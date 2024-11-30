extends InterfaceManager


@export var background: Node
@export var escape_menu: Menu

var active_menu: Node


func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		SC.toggle(get_window().mode, Window.MODE_WINDOWED, Window.MODE_FULLSCREEN)
	
	if event.is_action_pressed("escape"):
		open_menu(escape_menu)


func open_menu(menu: Menu) -> void:
	if active_menu:
		active_menu.close()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if menu.show_mouse else Input.MOUSE_MODE_CAPTURED
	get_tree().paused = menu.pause_game
	
	if menu.use_background:
		background.open()
	else:
		background.close()
	
	menu.open()
	active_menu = menu


func close_menu(menu: Menu) -> void:
	if menu.close_destination:
		open_menu(menu.close_destination)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		background.close()
		menu.close()
