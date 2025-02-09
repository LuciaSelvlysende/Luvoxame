class_name SC
extends RefCounted


## An array of 4 [Vector2]s that represent the corners of a 2x2 rectangle centered on (0, 0).
const CORNERS_ARRAY_2D: Array[Vector2] = [
	Vector2(1, 1),
	Vector2(1, -1),
	Vector2(-1, 1),
	Vector2(-1, -1),
]


## Returns ALL parents of the specified [param Node].
static func get_ancestors(node: Node) -> Array[Node]:
	var parent: Node = node.get_parent()
	var ancestors: Array[Node] = [parent]
	
	while parent != node.get_tree().root:
		parent = parent.get_parent()
		ancestors.append(parent)
	
	return ancestors

## Returns ALL children, grandchildren, etc. of the specified [param Node].
static func get_decendents(node: Node):
	var decendents: Array[Node] = []
	
	for child in node.get_children():
		decendents.append_array(get_decendents(child))
	
	return node.get_children() + decendents


## Toggles [param variable] between two states. If the current value is neither of the two provided values, the original value will be returned instead.
static func toggle(variable, value_a = true, value_b = false) -> Variant:
	if variable == value_a:
		return value_b
	
	if variable == value_b:
		return value_a
	
	return variable


## Erases all values of [array_b] from [param array_a] if present.
static func erase_array(array_a: Array, array_b: Array) -> Array:
	for element in array_b:
		array_a.erase(element)
	
	return array_a


## If [param has_all] is [code]true[/code], checks if array_a has [b]all[/b] values of [param array_b]. Otherwise, checks if array_a has [b]any[/b] values of [param array_b].
static func has_array(array_a: Array, array_b: Array, has_all: bool = true) -> bool:
	for element in array_b.duplicate():
		if array_a.has(element): continue
		if has_all: return false
		array_b.erase(element)
	
	return not array_b.is_empty()


## Equivalent to [method Array.reverse], but actually returns the reversed array.
static func reversed_array(array: Array) -> Array:
	var result: Array = array.duplicate()
	result.reverse()
	return result


## Merges an Array of Arrays into a single Array. The type of [param array] should be Array of Arrays, but for whatever reason that causes errors.
static func merged_nested_arrays(array: Array) -> Array:
	var merged_array: Array = []
	
	for nested_array in array:
		merged_array += nested_array
	
	return merged_array
