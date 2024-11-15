class_name SettingsLibrary
extends Resource


@export var object_path: NodePath
@export var settings: Array[Setting] = []

var object: Object


func _initialize(_root: Node) -> void:
	for setting in settings:
		setting.object = object
