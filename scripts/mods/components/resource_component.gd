class_name ResourceComponent
extends ModComponent


@export var resource_id: StringName
@export var resource: Resource


func _load_component() -> Error:
	return ResourceManager.add(resource, resource_id)
