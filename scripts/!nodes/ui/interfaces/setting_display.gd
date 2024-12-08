class_name SettingDisplay
extends Interface


signal load_display_value(load_value)
signal input_selected(type: InputTypes, property_info: Dictionary)

enum InputTypes {
	TOGGLE,
	DROPDOWN,
	SLIDER,
	TEXT_LINE,
}

@export var label: Label

var setting: Setting:
	set(value):
		setting = value
		label.text = setting.get_display_name()

var _type_selected: bool = false


func _load_display_value(value) -> void:
	if not _type_selected: select_type()
	load_display_value.emit(value)


func _on_input(value) -> void:
	setting.unconfirmed_value = value


func select_type() -> void:
	var property_info: Dictionary = setting.get_property_info()
	
	match property_info.type:
		TYPE_BOOL: 
			input_selected.emit(InputTypes.TOGGLE, property_info)
		TYPE_FLOAT, TYPE_INT: 
			input_selected.emit(InputTypes.SLIDER, property_info)
		TYPE_STRING, TYPE_STRING_NAME: 
			input_selected.emit(InputTypes.TEXT_LINE, property_info)
