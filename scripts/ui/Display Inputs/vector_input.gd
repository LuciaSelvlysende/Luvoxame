class_name VectorInput_Lvx
extends Interface


signal value_changed(value)

@export var input_type: SettingDisplay.InputTypes

@export_group("Node Connections")
@export var input_w: SpinBox
@export var input_x: SpinBox
@export var input_y: SpinBox
@export var input_z: SpinBox

var vector


func _on_input(_value) -> void:
	if vector is Vector2:
		vector = Vector2(input_x.value, input_y.value)
	if vector is Vector3:
		vector = Vector3(input_x.value, input_y.value, input_z.value)
	if vector is Vector4:
		vector = Vector4(input_w.value, input_x.value, input_y.value, input_z.value)
	
	value_changed.emit(vector)


func _on_input_selected(selected_type: SettingDisplay.InputTypes, property_info: Dictionary) -> void:
	visible = input_type == selected_type
	
	match property_info.type:
		TYPE_VECTOR2, TYPE_VECTOR2I:
			vector = Vector2.ZERO
			input_w.get_parent().get_parent().hide()
			input_z.get_parent().get_parent().hide()
		TYPE_VECTOR3, TYPE_VECTOR3I:
			vector = Vector3.ZERO
			input_w.get_parent().get_parent().hide()
		TYPE_VECTOR4, TYPE_VECTOR4I:
			vector = Vector4.ZERO


func _on_load_value(load_value) -> void:
	if not visible: return
	input_x.value = load_value.x
	input_y.value = load_value.y
	input_z.value = load_value.z
