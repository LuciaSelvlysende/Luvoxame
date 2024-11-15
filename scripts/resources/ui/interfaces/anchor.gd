class_name Anchor
extends Resource


enum Presets {
	USE_PROVIDED,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
	CENTER_LEFT,
	CENTER_TOP,
	CENTER_RIGHT,
	CENTER_BOTTOM,
	CENTER,
}


@export var parent_pathes: Array[NodePath] = [NodePath()]
@export var presets: Array[Presets] = [Presets.USE_PROVIDED]
@export var termini: Array[Vector2] = [Vector2.ZERO]
@export var weights: Array[Vector2] = [Vector2.ONE]

var parent: Interface
var parents: Array


func _initialize(_root):
	for index in termini.size():
		if presets[index] == Presets.USE_PROVIDED: continue
		termini[index] = apply_preset(presets[index])


func apply_preset(preset: Presets) -> Vector2:
	match preset:
		Presets.TOP_LEFT: return Vector2(0, 0)
		Presets.TOP_RIGHT: return Vector2(1, 0)
		Presets.BOTTOM_LEFT: return Vector2(0, 1)
		Presets.BOTTOM_RIGHT: return Vector2(1, 1)
		Presets.CENTER_LEFT: return Vector2(0, 0.5)
		Presets.CENTER_TOP: return Vector2(0.5, 0)
		Presets.CENTER_RIGHT: return Vector2(1, 0.5)
		Presets.CENTER_BOTTOM: return Vector2(0.5, 1)
		Presets.CENTER: return Vector2(0.5, 0.5)
		_: return Vector2.ZERO


func get_position(interface: Interface) -> Vector2:
	var positions: Array[Vector2] = []
	var total_weight: Vector2 = Vector2.ZERO
	
	for index in parents.size():
		if parents[index] is Interface:
			positions.append(termini[index] * (parents[index].size * parents[index].scale) + parents[index].position)
		else:
			positions.append(termini[index] * interface._window_size)
		
		positions[-1] *= weights[index]
		total_weight += weights[index]
	
	return Math.sum_v2_array(positions) / Math.replace_v2(total_weight, 0, 1)


func _get_update_packet_information(update_packet: InterfaceUpdatePacket):
	for i in 2: for parent in parents:
		if not parent or not weights[parents.find(parent)][i]: continue
		
		if InterfaceSynchronizer.has_update_packets(parent, [i]):
			update_packet.dependencies.append_array(InterfaceSynchronizer.get_interface_packets(parent, [i]))
			continue
		
		update_packet.components = Shcut.erase_array(update_packet.components, [i, i + 2])
