class_name IndexSelection
extends Resource


@export var selection: String


func _init(init_selection: String = "") -> void:
	selection = init_selection


func parse() -> Array[int]:
	selection.replace(" ", "")
	var fragments: Array = Array(selection.split(","))
	var indicies: Array[int]
	
	for fragment in fragments:
		# Single indicies (ex: 1, 7, 2).
		if not fragment.contains("-"):
			indicies.append(fragment.to_int())
		
		# Index ranges (ex: 1-6, 5-9).
		if fragment.contains("-"):
			var range_bounds: PackedStringArray = fragment.split("-")
			var lower_bound: int = range_bounds[0].to_int()
			var upper_bound: int = range_bounds[1].to_int()
		
			for index in upper_bound - lower_bound + 1:
				indicies.append(lower_bound + index)
	
	return indicies


func can_map(to_selection: IndexSelection) -> bool:
	if has_duplicates(): return false
	if to_selection.has_duplicates(): return false
	if parse().size() != to_selection.parse().size(): return false
	return true


func has_duplicates() -> bool:
	var indicies: Array[int] = parse()
	var check_indicies: Array[int] = indicies.duplicate()
	
	for check_index in check_indicies:
		indicies.erase(check_index)
		if indicies.has(check_index): return true
	
	return false
