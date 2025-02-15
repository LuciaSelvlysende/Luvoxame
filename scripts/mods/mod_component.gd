class_name ModComponent
extends Resource


@export var external_dependencies: Array[StringName] = []
@export var internal_dependencies: Array[StringName] = []

var mod: Mod


func _load_component() -> Error:
	return Error.OK
