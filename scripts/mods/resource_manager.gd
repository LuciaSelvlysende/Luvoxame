class_name ResourceManager
extends RefCounted


static var resources: Dictionary = {}


static func add(resource: Resource, id: StringName) -> Error:
	if resources.keys().has(id): return ERR_ALREADY_EXISTS
	resources[id] = resource
	return OK


static func clean() -> Array[StringName]:
	var removed_resources: Array[StringName]
	
	for id in resources.keys():
		if resources[id].get_reference_count() > 1: continue
		removed_resources.append(id)
		resources.erase(id)
	
	return removed_resources


static func access(id: StringName) -> Resource:
	return resources.get(id)


static func access_array(ids: Array[StringName]) -> Array[Resource]:
	var result: Array[Resource] = []
	
	for id in ids:
		result.append(resources.get(id))
	
	return result
