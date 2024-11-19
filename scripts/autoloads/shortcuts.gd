class_name ShortcutsAutoload
extends Node


## An array of 4 [Vector2]s that represent the corners of a 2x2 rectangle centered on (0, 0).
const CORNERS_ARRAY_2D: Array[Vector2] = [
	Vector2(1, 1),
	Vector2(1, -1),
	Vector2(-1, 1),
	Vector2(-1, -1),
]


func get_ancestors(node: Node) -> Array[Node]:
	var parent: Node = node.get_parent()
	var ancestors: Array[Node] = [parent]
	
	while parent != get_tree().root:
		parent = parent.get_parent()
		ancestors.append(parent)
	
	return ancestors


func get_decendents(node: Node):
	var decendents: Array[Node] = []
	
	for child in node.get_children():
		decendents.append_array(get_decendents(child))
	
	return node.get_children() + decendents


## Toggles [param variable] between two states. If the current value is neither of the two provided values, the original value will be returned instead.
func toggle_variable(variable, value_a = true, value_b = false) -> Variant:
	if variable == value_a:
		return value_b
	
	if variable == value_b:
		return value_a
	
	return variable


## Returns a [Vector2] where all components are equal to the provided [param value].
func eq_v2(value: float) -> Vector2:
	return Vector2(value, value)


## Returns a [Vector3] where all components are equal to the provided [param value].
func eq_v3(value: float) -> Vector3:
	return Vector3(value, value, value)


func erase_array(array_a: Array, array_b: Array) -> Array:
	for element in array_b:
		array_a.erase(element)
	
	return array_a


func has_array(array_a: Array, array_b: Array, includes_all: bool = true) -> bool:
	for element in array_b.duplicate():
		if array_a.has(element): continue
		if includes_all: return false
		array_b.erase(element)
	
	return not array_b.is_empty()


func reversed_array(array: Array) -> Array:
	var result: Array = array.duplicate()
	result.reverse()
	return result


func merged_nested_arrays(array: Array[Array]) -> Array:
	var merged_array: Array
	
	for nested_array in array:
		merged_array += nested_array
	
	return merged_array
