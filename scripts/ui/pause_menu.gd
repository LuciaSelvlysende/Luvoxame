extends Menu


@export var settings_destination: Menu


func open():
	animation_player.play("open_pause_menu")
	super()


func close(ignore_visibility: bool = true):
	animation_player.play("close_pause_menu")
	animation_player.queue("reset_pause_menu")
	super(ignore_visibility)


func _on_return_button():
	close()


func _on_settings_button():
	settings_destination.open()
	close()


func _on_quit_button():
	get_tree().quit()
