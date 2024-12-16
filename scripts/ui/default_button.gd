class_name DefaultButton
extends Interface


signal pressed

@export var text: String:
	set(value):
		if label:
			label.text = value
		text = value

@export_group("Node Connections")
@export var label: Label
@export var button: BaseButton


func _on_button_up() -> void:
	label.position += Vector2.UP
	pressed.emit()


func _on_button_down() -> void:
	label.position += Vector2.DOWN


func disable() -> void:
	button.disabled = true


func enable() -> void:
	button.disabled = false
