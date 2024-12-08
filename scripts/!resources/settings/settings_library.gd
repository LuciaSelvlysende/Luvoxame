class_name SettingsLibrary
extends Resource

## Stores [Setting]s pertaining to a particular [object].


@export var object_path: NodePath  ## The path to [object]. Must start with "Game/". 
@export var settings: Array[Setting] = []  ## An array of [Setting]s that apply to [member object].

var object: Object  ## The [Object] that [member settings] apply to.


func _initialize(_root: Node) -> void:
	for setting in settings:
		setting.object = object
