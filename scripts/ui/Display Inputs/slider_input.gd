class_name SliderInput_Lvx
extends HSlider


@export var input_type: SettingDisplay.InputTypes


func _on_input_selected(selected_type: SettingDisplay.InputTypes, property_info: Dictionary) -> void:
	return
	visible = input_type == selected_type
	if not visible: return
	
	var string_fragments: PackedStringArray = property_info.hint_string.split(",", false, 5)
	if string_fragments.is_empty(): return
	
	min_value = string_fragments[0] as float
	max_value = string_fragments[1] as float
	
	allow_lesser = string_fragments.has("or_lesser")
	allow_greater = string_fragments.has("or_greater")
	
	if string_fragments.size() < 3: return
	if string_fragments[2] != str(string_fragments[2] as float): return
	step = string_fragments[2] as float


func _on_load_value(load_value) -> void:
	if not visible: return
	value = load_value
