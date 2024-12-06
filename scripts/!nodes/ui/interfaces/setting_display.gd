class_name SettingDisplay
extends Interface

## Skipping documentation for this one, since it will be completely reworked next update (in1.2.1).


enum InputTypes {
	TOGGLE,
	DROPDOWN,
	SLIDER,
	TEXT_LINE,
}

@export var label: Label
@export var toggle_input: CheckButton
@export var dropdown_input: OptionButton
@export var slider_input: HSlider
@export var text_line_input: LineEdit

var setting: Setting


static func create(setting: Setting, manager: SettingsManager) -> void:
	# Set up display.
	setting.display = manager.display_scene.instantiate()
	setting.display.setting = setting
	setting.display.label.text = setting.get_display_name()
	setting.display.connect_input(setting.type)
	
	# Add display.
	setting.group.add_display(setting.display)


func connect_input(input_type: InputTypes) -> void:
	match input_type:
		InputTypes.TOGGLE:
			toggle_input.toggled.connect(update_setting_value)
			toggle_input.visible = true
		InputTypes.DROPDOWN:
			dropdown_input.item_selected.connect(update_setting_value)
			dropdown_input.visible = true
		InputTypes.SLIDER:
			slider_input.drag_ended.connect(update_setting_value)
			slider_input.visible = true
		InputTypes.TEXT_LINE:
			text_line_input.text_submitted.connect(update_setting_value)
			text_line_input.visible = true


func update_setting_value(parameter) -> void:
	match setting.type:
		InputTypes.SLIDER: setting.unconfirmed_value = slider_input.value
		_: setting.unconfirmed_value = parameter


func update_display_value(value) -> void:
	match setting.type:
		InputTypes.TOGGLE: toggle_input.button_pressed = value
		InputTypes.DROPDOWN: dropdown_input.selected = value
		InputTypes.TEXT_LINE: text_line_input.text = value
		InputTypes.SLIDER:
			var slider_info: Array = setting.get_slider_info()
			slider_input.value = value
			slider_input.min_value = slider_info[0]
			slider_input.max_value = slider_info[1]
			slider_input.step = slider_info[2]
			slider_input.allow_lesser = slider_info[3]
			slider_input.allow_greater = slider_info[4]
