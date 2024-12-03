class_name PauseMenuScript_Lvx
extends Menu

## Script for the pause menu.
##
## Responsible for handling button inputs within the pause menu.


@export var settings_destination: Menu  ## The [Menu] that is opened by pressing the settings button.


func _on_return_button():
	manager.close_menu(self)


func _on_settings_button():
	manager.open_menu(settings_destination)


func _on_quit_button():
	get_tree().quit()
