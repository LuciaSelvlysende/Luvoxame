extends Menu


@export var settings_destination: Menu


func _on_return_button():
	manager.close_menu(self)


func _on_settings_button():
	manager.open_menu(settings_destination)


func _on_quit_button():
	get_tree().quit()
