class_name SizeReference
extends Resource


enum UpdateModes {
	CHANGE_SIZE,
	CHANGE_SCALE,
}

@export var reference_node_pathes: Array[NodePath] = [NodePath()]
@export var multipliers: Array[Vector2] = [Vector2.ONE]
@export var update_mode: UpdateModes = UpdateModes.CHANGE_SCALE

var base_size: Vector2
var reference_nodes: Array[Node]
var manager: InterfaceManager


func _initialize(root):
	manager = root.manager


func get_size(require_current: bool = false) -> Vector2:
	if not require_current and base_size and update_mode == UpdateModes.CHANGE_SCALE: return base_size
	
	var reference_values: Array[Vector2] = []
	
	for index in reference_nodes.size():
		if reference_nodes[index]:
			reference_values.append(reference_nodes[index].size * reference_nodes[index].scale * multipliers[index])
		else:
			reference_values.append(manager.window_size * multipliers[index])
	
	return Math.sum_v2_array(reference_values)


func get_scale() -> Vector2:
	return get_size(true) / base_size if base_size else get_size().sign()


func _get_update_packet_information(update_packet: InterfaceUpdatePacket):
	for i in 2: for index in reference_nodes.size():
		if not reference_nodes[index] is Interface or not multipliers[index][i]: continue
		if not manager.get_missing_components(reference_nodes[index], [i]): continue
		update_packet.components = SC.erase_array(update_packet.components, [i, i + 2])
