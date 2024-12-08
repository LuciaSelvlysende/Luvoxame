class_name Setting
extends Resource

## A [Resource] that facilitates in-game modification of [Object] properties.
##
## [Setting]s handle modifictaion of [member property] of [member object]. [Setting]s are organized
## into [SettingsCategory]s and [SettingsGroup]s.


@export var property: StringName  ## The name of the property of [member object] that is modified by the Setting.
@export var type: SettingDisplay.InputTypes  ## The type of input that the Setting uses. See [enum SettingDisplay.InputTypes].
@export var name_override: String  ## Overrides the label used by the [SettingDisplay].
@export var subdivision_ids: Array[StringName] = []

var subdivisions: Array[Node] = []
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
	display._load_display_value(confirmed_value)


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


func get_property_info() -> Dictionary:
	for property_dictionary in object.get_property_list():
		if property_dictionary.name == property: return property_dictionary
	
	return Dictionary()
