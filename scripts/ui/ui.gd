class_name UIScript_Lvx
extends InterfaceManager

## A more advanced [InterfaceManager] specialized for Luvoxame.
##
## There are some issues with opening and closing a Menu simultaneously, they should be fixed soon.


@export var background: Node  ## The default background used while a [Menu] is opened.
@export var escape_menu: Menu  ## The menu opened by pressing escape, typically the pause menu.

var active_menu: Node  ## The menu that is currently being displayed.


func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		SC.toggle(get_window().mode, Window.MODE_WINDOWED, Window.MODE_FULLSCREEN)
	
	if event.is_action_pressed("escape"):
		if not active_menu:
			open_menu(escape_menu)
		elif active_menu == escape_menu:
			close_menu(escape_menu)
		else:
			close_menu(active_menu)


## Opens a [Menu], closing the currently [member active_menu], and making the provided [param menu] the new [member active_menu].
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


## Closes the provided [param menu], and opens that menu's [member Menu.close_destination] menu.
func close_menu(menu: Menu) -> void:
	if menu.close_destination:
		open_menu(menu.close_destination)
	else:  # This occurs when all menus are closed.
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
		background.close()
		menu.close()
		active_menu = null
