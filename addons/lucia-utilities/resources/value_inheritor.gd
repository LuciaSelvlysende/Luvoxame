class_name ValueInheritor
extends Resource


enum ArrayMergeModes {
	NO_MERGE,
	PUSH_FRONT,
	PUSH_BACK,
}

@export var include: Array[StringName] = []
@export var exclude: Array[StringName] = []
@export var default_merge_mode: ArrayMergeModes
@export var merge_modes: Dictionary[StringName, ArrayMergeModes] = {}

var child: Object
var parent: Object
var default_object: Object
var exclude_object: Object


func inherit(child_object: Object = null, parent_object: Object = null) -> void:
	if child_object:
		child = child_object
	if parent_object:
		parent = parent_object
	
	if not (child and parent): return
	
	for property in _get_included_properties():
		if property.type == TYPE_ARRAY: 
			_merge_array(property, merge_modes[property.name] if merge_modes.has(property.name) else default_merge_mode)
		else:
			child.set(property.name, parent.get(property.name))


func _get_included_properties() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	for property in child.get_property_list():
		if [PROPERTY_USAGE_CATEGORY, PROPERTY_USAGE_GROUP, PROPERTY_USAGE_SUBGROUP].has(property.usage): continue
		if property.name in exclude_object: continue
		if exclude.has(property.name): continue
		if include and not include.has(property.name): continue
		if child.get(property.name) != default_object.get(property.name): continue
		if child.get(property.name) == parent.get(property.name): continue
		properties.append(property)
	
	return properties


func _merge_array(property: Dictionary, merge_mode: ArrayMergeModes) -> void:
	match merge_mode:
		ArrayMergeModes.NO_MERGE:
			child.get(property.name).assign(parent.get(property.name))
		ArrayMergeModes.PUSH_FRONT:
			Arrays.push_front_array(child.get(property.name), parent.get(property.name))
		ArrayMergeModes.PUSH_BACK:
			child.get(property.name).append_array(parent.get(property.name))
