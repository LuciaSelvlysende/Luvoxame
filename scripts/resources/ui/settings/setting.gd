class_name Setting
extends Resource


@export var property: StringName  ## The name of the property of [member object] that is modified by the Setting.
@export var type: SettingDisplay.InputTypes  ## The type of input that the Setting uses. See [enum SettingDisplay.InputTypes].

@export_group("Organization")
@export var name_override: String  ## Overrides the label used by the [SettingDisplay].
@export var category_id: StringName  ## The id of the [SettingsCategory] to which the Setting belongs.
@export var group_id: StringName  ## The id of the [SettingsGroup] to which the Setting belongs.

var category: SettingsCategory  ## The [SettingsCategory] to which the Setting belongs.
var group: SettingsGroup  ## The [SettingsGroup] to which the Setting belongs.
var display: SettingDisplay  ## The [SettingsDisplay] that provides an interface for the Setting in the settings menu.

var default_value  ## Unimplemented. This will be the original value of [member property].
var confirmed_value  ## The value that is used when updating the [SettingDisplay] and for modifying the value of [member property]. When settings are saved, the [member unconfirmed_value] is copied to the [member confirmed_value].
var unconfirmed_value  ## The value that the [SettingDisplay] directly modifies.

var object: Object  ## The object that has the [member property] modified by the Setting.


## Connects signals from the [SettingsManager] to their appropriate functions.
func connect_signals(manager: SettingsManager) -> void:
	manager.load_settings.connect(update)
	manager.save_settings.connect(save)
	manager.discard_settings.connect(discard)


## Updates the display with the current values from the [object].
func update() -> void:
	confirmed_value = object.get(property)
	display.update_display_value(confirmed_value)


## Saves the new settings and applies them to the [member object].
func save() -> void:
	confirmed_value = unconfirmed_value
	object.set(property, confirmed_value)


## Does nothing, will be expanded upon later.
func discard() -> void:
	object.set(property, confirmed_value)  # Yes, this is nothing.


## Gets a name for the [SettingDisplay].
func get_display_name() -> String:
	return name_override if name_override else property.capitalize()


## Gets the slider information that the [SettingDisplay] needs.
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
