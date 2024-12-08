class_name NumberInputBox_Lvx
extends SpinBox


func _on_slider_input(slider_value) -> void:
	value = slider_value


func update_range(range_min: Variant, range_max: Variant, range_step: Variant, range_allow_lesser: Variant, range_allow_greater: Variant) -> void:
	min_value = range_min
	max_value = range_max
	step = clamp(range_step, 0.001, INF)
	allow_lesser = range_allow_lesser
	allow_greater = range_allow_greater
