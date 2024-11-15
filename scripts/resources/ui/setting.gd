class_name Setting
extends Resource


@export var property: StringName
@export var type: SettingDisplay.InputTypes

@export_group("Organization")
@export var name_override: String
@export var category_id: StringName
@export var group_id: StringName

var category: SettingsCategory
var group: SettingsGroup
var display: SettingDisplay

var default_value
var confirmed_value
var unconfirmed_value

var object: Object


func connect_signals(manager: SettingsManager) -> void:
	manager.load_settings.connect(update)
	manager.save_settings.connect(save)
	manager.discard_settings.connect(discard)


func update() -> void:
	confirmed_value = object.get(property)
	display.update_display_value(confirmed_value)


func save() -> void:
	confirmed_value = unconfirmed_value
	object.set(property, confirmed_value)


func discard() -> void:
	object.set(property, confirmed_value)


func get_display_name() -> String:
	return name_override if name_override else property.capitalize()


func get_slider_info() -> Array:
	var string_fragments: PackedStringArray
	var slider_info: Array = [0, 100, 1, false, false]

	for object_property in object.get_property_list():
		if not object_property["name"] == property: continue
		if not object_property["hint"] == PROPERTY_HINT_RANGE: continue
		string_fragments = object_property["hint_string"].split(",", false, 5)
		break
	
	for index in string_fragments.size():
		if index <= 1:
			slider_info[index] = string_fragments[index] as float
		elif string_fragments[index] == str(string_fragments[index] as float):
			slider_info[2] = string_fragments[index] as float
		elif string_fragments[index] == "or_greater":
			slider_info[3] = true
		elif string_fragments[index] == "or_less":
			slider_info[4] = true
	
	return slider_info
