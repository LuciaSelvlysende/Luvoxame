class_name InputInput_Lvx
extends Interface


@export var input_type: SettingDisplay.InputTypes

@export_group("Node Connections")
@export var button: DefaultButton

var accepting_input: bool = false
var action: StringName


func _input(event: InputEvent) -> void:
	if not accepting_input: return
	if not event.is_action_type(): return
	if event.as_text() == "Escape (Physical)": return
	
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	
	button.text = _get_event_name(event)
	accepting_input = false
	
	get_viewport().set_input_as_handled()
	button.enable()


func _on_input() -> void:
	button.text = "Press key..."
	button.disable()
	accepting_input = true


func _on_input_selected(selected_type: SettingDisplay.InputTypes, property_info: Dictionary) -> void:
	visible = input_type == selected_type
	action = property_info.name


func _on_load_value(load_value) -> void:
	if not visible: return
	
	var button_text: String
	
	for event in load_value:
		button_text += _get_event_name(event) + " "
	
	button.text = button_text.left(-1)


func _get_event_name(event: InputEvent) -> String:
	return event.as_text().trim_suffix(" (Physical)")
