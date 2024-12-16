class_name InputSettings_Lvx
extends Node


@export var actions: Dictionary = {}  # TYPE: Dictionary[StringName (group_id), Array[StringName] (actions)]
@export var base_setting: Setting

@export_group("Node Connections")
@export var settings_manager: SettingsManager

var settings_library: SettingsLibrary = SettingsLibrary.new()


func _ready() -> void:
	settings_library.object = self
	
	for action_group in actions.keys(): for action in actions[action_group]:
		var setting: Setting = base_setting.duplicate()
		setting.property = action
		setting.subdivision_ids[1] = action_group
		settings_library.settings.append(setting)
	
	settings_manager.add_settings_library(settings_library)


func _get_setting_property_info(setting: Setting) -> Dictionary:
	var property_info: Dictionary = {
		"name" = setting.property,
		"class_name" = "InputEvent",
		"type" = TYPE_OBJECT,
		"hint" = PROPERTY_HINT_NONE,
		"hint_string" = "",
		"usage" = PROPERTY_USAGE_DEFAULT,
	}
	
	return property_info


func _load_setting(setting: Setting) -> Array[InputEvent]:
	return InputMap.action_get_events(setting.property)


func _save_setting(setting: Setting) -> void:
	pass
