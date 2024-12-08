class_name SliderInput2_Lvx
extends Interface


@export var input_type: SettingDisplay.InputTypes

@export_group("Node Connections")
@export var slider: HSlider
@export var box: SpinBox


func _on_input_selected(selected_type: SettingDisplay.InputTypes, property_info: Dictionary) -> void:
	visible = input_type == selected_type
	if not visible: return
	
	var string_fragments: PackedStringArray = property_info.hint_string.split(",", false, 5)
	var min_value: float = 0
	var max_value: float = 100
	var step: float = 0.01
	var allow_lesser: bool = false
	var allow_greater: bool = false
	
	if not string_fragments.is_empty():
		min_value = string_fragments[0] as float
		max_value = string_fragments[1] as float
		allow_lesser = string_fragments.has("or_lesser")
		allow_greater = string_fragments.has("or_greater")
	
	if string_fragments.size() > 2 and string_fragments[2] != str(string_fragments[2] as float):
		step = string_fragments[2] as float
	
	slider.update_range(min_value, max_value, step, allow_lesser, allow_greater)
	box.update_range(min_value, max_value, step, allow_lesser, allow_greater)


func _on_load_value(load_value) -> void:
	if not visible: return
	slider.value = load_value
	box.value = load_value
