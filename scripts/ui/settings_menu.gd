extends Menu


@export var close_destination: Menu


func open():
	animation_player.play("open_settings_menu")
	super()


func close(ignore_visibility: bool = true) -> void:
	close_destination.open()
	animation_player.play("close_settings_menu")
	animation_player.queue("reset_settings_menu")
	super(ignore_visibility)


func _on_save_button() -> void:
	save()
	close()


func _on_cancel_button() -> void:
	close()


func save() -> void:
	pass
