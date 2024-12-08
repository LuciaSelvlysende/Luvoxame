class_name ToggleInput_Lvx
extends CheckButton


@export var input_type: SettingDisplay.InputTypes


func _on_input_selected(selected_type: SettingDisplay.InputTypes, property_info: Dictionary) -> void:
	visible = input_type == selected_type


func _on_load_value(load_value) -> void:
	if not visible: return
	button_pressed = load_value
