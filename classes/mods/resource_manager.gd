class_name ResourceManager
extends Node


var resources: Dictionary[StringName, Resource] = {}

@onready var _exports: Node = $/root/Game


func _ready() -> void:
	if not _exports: return
	resources = _exports.resources


func add(resource: Resource, id: StringName) -> Error:
	if resources.keys().has(id): return ERR_ALREADY_EXISTS
	resources[id] = resource
	return OK


func access(id: StringName) -> Resource:
	return resources.get(id)


func access_array(ids: Array[StringName]) -> Array[Resource]:
	var result: Array[Resource] = []
	
	for id in ids:
		result.append(resources.get(id))
	
	return result


func assign(object: Object, ids: Array, properties: Array[StringName], assign_null: bool = false) -> void:
	if not (object and ids and properties): return
	if ids.size() != properties.size(): return
	
	for index in ids.size():
		@warning_ignore("incompatible_ternary")
		var value: Variant = access_array(ids[index]) if ids[index] is Array else access(ids[index])
		if not assign_null and not value: continue
		
		if ids[index] is Array:
			object.get(properties[index]).assign(value)
		else:
			object.set(properties[index], value)
