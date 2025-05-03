#class_name Margin
#extends Resource
#
### A resource used by [Interface]s to create a margin around the Interface.
###
### A margin is created by increasing the size of the Interface by the entire margin,
### and then moving all child nodes of the Interface by the left and top margins.
#
#
#@export_node_path("Interface") var margin_reference_path: NodePath  ## The path used by [ResourceInitializer] to determine [member margin_reference]. By default, [member margin_reference] will be set to the Interface that this Margin belongs to.
#@export var trim_reference_margin: bool = true  ## When [code]true[/code], the margin of the [member margin_reference] will be ignored.
#@export var margin_left: float = 0  ## The margin to the left (-x) of the Interface. Relative to [member margin_reference]'s size.
#@export var margin_top: float = 0  ## The margin to the left (-y) of the Interface. Relative to [member margin_reference]'s size.
#@export var margin_right: float = 0  ## The margin to the left (+x) of the Interface. Relative to [member margin_reference]'s size.
#@export var margin_bottom: float = 0  ## The margin to the left (+y) of the Interface. Relative to [member margin_reference]'s size.
#
#var margin: Rect2 = Rect2()  ## A [Rect2] that represents the margin. Created when the Margin resource is initialized with [ResourceInitializer].
#var margin_reference: Interface  ## The node that the margin units are relative to. By default, will be set to the Interface that this Margin belongs to.
#var manager: InterfaceManager  ## The [InterfaceManager] responsible for the [Interface] to which the Margin belongs.
#
#
#func _initialize(root: Node) -> void:
	#margin.position = Vector2(margin_left, margin_top)
	#margin.size = margin.position + Vector2(margin_right, margin_bottom)
	#manager = root.manager
	#
	#if margin_reference: return
	#margin_reference = root
#
#
### Applies the margin to the provided [param interface]. This includes increasing the size of the Interface by the entire margin, and then moving all child nodes of the Interface by the left and top margins.
#func apply(interface: Interface):
	#var margin_reference_size: Vector2 = margin_reference.base_rect.size if trim_reference_margin else margin_reference.full_rect.size
	#
	#interface.base_rect.position = margin.position * margin_reference_size
	#interface.full_rect.size = interface.base_rect.size + margin_reference_size * margin.size
	#
	#for child in interface.filter_children(Interface.ChildFilter.CONTROL):
		#child.position = interface.base_rect.position
	#
	#for child in interface.filter_children(Interface.ChildFilter.INTERFACE):
		#if child._margin_adjusted == true: continue
		#child.position += interface.base_rect.position
		#child._margin_adjusted = true
#
#
## Gets information used for creating an InterfaceUpdatePacket. See InterfaceManager._create_update_packet() for more details.
#func _get_update_packet_information(update_packet: InterfaceUpdatePacket):
	#for i in 2:
		#if update_packet.interface == margin_reference or not (margin.position[i] + margin.size[i]): continue
		#if not manager.get_missing_components(margin_reference, [i]): continue
		#update_packet.components = SC.erase_array(update_packet.components, [i, i + 2])
