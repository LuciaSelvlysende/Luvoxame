class_name SC
extends RefCounted


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
