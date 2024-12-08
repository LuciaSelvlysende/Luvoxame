class_name NumberInputSlider_Lvx
extends HSlider


func _on_box_input(box_value) -> void:
	value = box_value


func update_range(range_min: Variant, range_max: Variant, range_step: Variant, range_allow_lesser: Variant, range_allow_greater: Variant) -> void:
	min_value = range_min
	max_value = range_max
	step = range_step
	allow_lesser = range_allow_lesser
	allow_greater = range_allow_greater
