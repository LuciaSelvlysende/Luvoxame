#class_name SizeReference
#extends Resource
#
### A resource used by [Interface]s to base it's size on one or more other Interfaces.
###
### [b]Note:[/b] The values of the [member reference_nodes] and [member multipliers] arrays correspond
### to eachother. For example, [code]multipliers[2][/code] is the multiplier for [code][reference_nodes[2][/code].
#
#
#enum UpdateModes {
	#CHANGE_SIZE,  ## [method get_size] will return continually updated sizes. Scaling should be disabled on the Interface.
	#CHANGE_SCALE,  ## [method get_size] will only return the initial size. If scaling is enabled on the Interface, [method Interface.update] will use [method get_scale] to update scale.
#}
#
#@export var reference_node_pathes: Array[NodePath] = [NodePath()]  ## The pathes used by [ResourceInitializer] to determine [member reference_nodes].
#@export var multipliers: Array[Vector2] = [Vector2.ONE]  ## A multiplier applied to the size of the corresponding reference_node in [member reference_nodes].
#@export var update_mode: UpdateModes = UpdateModes.CHANGE_SCALE  ## Determines the mode used for updating the size of the Interface as the size of the [member reference_nodes] changes. See [enum UpdateModes].
#
#var base_size: Vector2  ## The combined size of [member reference_nodes] from the first update. Used by [method get_scale] if [member update_modes] is set to [constant CHANGE_SCALE].
#var reference_nodes: Array[Node]  ## The nodes that the size of the Interface is based upon.
#var manager: InterfaceManager  ## The [InterfaceManager] responsible for the [Interface] to which the SizeReference belongs.
#
#
#func _initialize(root):
	#manager = root.manager
#
#
### Returns the sum of the size of [member reference_nodes], each multiplied by their corresponding multiplier in [member multipliers].
#func get_size(require_current: bool = false) -> Vector2:
	#if not require_current and base_size and update_mode == UpdateModes.CHANGE_SCALE: return base_size
	#
	#var reference_values: Array[Vector2] = []
	#
	#for index in reference_nodes.size():
		#if reference_nodes[index]:
			#reference_values.append(reference_nodes[index].size * reference_nodes[index].scale * multipliers[index])
		#else:
			#reference_values.append(manager.window_size * multipliers[index])
	#
	#return Vectors.sum_array(reference_values)
#
#
### Returns the scale found by dividing the current result of [method get_size] by the initial result of [method get_size].
#func get_scale() -> Vector2:
	#return get_size(true) / base_size if base_size else get_size().sign()
#
#
## Gets information used for creating an InterfaceUpdatePacket. See InterfaceManager._create_update_packet() for more details.
#func _get_update_packet_information(update_packet: InterfaceUpdatePacket):
	#for i in 2: for index in reference_nodes.size():
		#if not reference_nodes[index] is Interface or not multipliers[index][i]: continue
		#if not manager.get_missing_components(reference_nodes[index], [i]): continue
		#update_packet.components = SC.erase_array(update_packet.components, [i, i + 2])
