#class_name Anchor
#extends Resource
#
### A resource used by [Interface]s to control their position.
###
### [b]Note:[/b] The values of the [member parents], [member presets], [member termini], and [member weights]
### arrays correspond to eachother. For example, [code]termini[2][/code] is the terminus for [code]reference_nodes[2][/code].
#
#
#enum Presets {
	#USE_PROVIDED,  ## Does not override the corresponding index in [member termini].
	#TOP_LEFT,  ## Sets the corresponding index in [member termini] to [code]Vector2(0, 0)[/code].
	#TOP_RIGHT,  ## Sets the corresponding index in [member termini] to [code]Vector2(1, 0)[/code].
	#BOTTOM_LEFT,  ## Sets the corresponding index in [member termini] to [code]Vector2(0, 1)[/code].
	#BOTTOM_RIGHT,  ## Sets the corresponding index in [member termini] to [code]Vector2(1, 1)[/code].
	#CENTER_LEFT,  ## Sets the corresponding index in [member termini] to [code]Vector2(0, 0.5)[/code].
	#CENTER_TOP,  ## Sets the corresponding index in [member termini] to [code]Vector2(0.5, 0)[/code].
	#CENTER_RIGHT,  ## Sets the corresponding index in [member termini] to [code]Vector2(1, 0.5)[/code].
	#CENTER_BOTTOM,  ## Sets the corresponding index in [member termini] to [code]Vector2(0.5, 1)[/code].
	#CENTER,  ## Sets the corresponding index in [member termini] to [code]Vector2(0.5, 0.5)[/code].
#}
#
#
#@export var parent_pathes: Array[NodePath] = [NodePath()]  ## The pathes used by [ResourceInitializer] to determine [member parents].
#@export var presets: Array[Presets] = [Presets.USE_PROVIDED]  ## Various presets that determine the corresponding terminus in [member termini]. See [enum Presets].
#@export var termini: Array[Vector2] = [Vector2.ZERO]  ## The position that the [Interface.origin] will be moved to, relative to the corresponding node in [parents].
#@export var weights: Array[Vector2] = [Vector2.ONE]  ## A weight applied to a particular terminus. The weighted [termini] are then averaged to get a final position.
#
#var parents: Array  ## The nodes that the Anchor will position the [Interface] relative to.
#var manager: InterfaceManager  ## The [InterfaceManager] responsible for the [Interface] to which the Anchor belongs.
#
#
#func _initialize(root):
	#manager = root.manager
	#
	## Apply termini presets.
	#termini.resize(presets.size())
	#for index in termini.size():
		#if presets[index] == Presets.USE_PROVIDED: continue
		#termini[index] = _apply_preset(presets[index])
#
#
### Returns the global position that [Interface.origin] will be moved to.
#func get_position() -> Vector2:
	#var positions: Array[Vector2] = []
	#var total_weight: Vector2 = Vector2.ZERO
	#
	#for index in parents.size():
		#if parents[index] is Interface:
			#positions.append(termini[index] * (parents[index].size * parents[index].scale) + parents[index].position)
		#else:
			#positions.append(termini[index] * manager.window_size)
		#
		#positions[-1] *= weights[index]
		#total_weight += weights[index]
	#
	#return Vectors.sum_array(positions) / Vectors.replace(total_weight, 0, 1)
#
#
## Applies a preset to the corresponding terminus.
#func _apply_preset(preset: Presets) -> Vector2:
	#match preset:
		#Presets.TOP_LEFT: return Vector2(0, 0)
		#Presets.TOP_RIGHT: return Vector2(1, 0)
		#Presets.BOTTOM_LEFT: return Vector2(0, 1)
		#Presets.BOTTOM_RIGHT: return Vector2(1, 1)
		#Presets.CENTER_LEFT: return Vector2(0, 0.5)
		#Presets.CENTER_TOP: return Vector2(0.5, 0)
		#Presets.CENTER_RIGHT: return Vector2(1, 0.5)
		#Presets.CENTER_BOTTOM: return Vector2(0.5, 1)
		#Presets.CENTER: return Vector2(0.5, 0.5)
		#_: return Vector2.ZERO
#
#
## Gets information used for creating an InterfaceUpdatePacket. See InterfaceManager._create_update_packet() for more details.
#func _get_update_packet_information(update_packet: InterfaceUpdatePacket):
	#for i in 2: for parent in parents:
		#if not parent or not weights[parents.find(parent)][i]: continue
		#if not manager.get_missing_components(parent, [i, i + 2]): continue
		#update_packet.components = SC.erase_array(update_packet.components, [i + 2])
