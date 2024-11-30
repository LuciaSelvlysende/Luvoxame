class_name Margin
extends Resource


@export_node_path("Interface") var margin_reference_path: NodePath
@export var trim_reference_margin: bool = true
@export var margin_left: float = 0
@export var margin_top: float = 0
@export var margin_right: float = 0
@export var margin_bottom: float = 0

var margin: Rect2 = Rect2()
var margin_reference: Interface
var manager: InterfaceManager


func _initialize(root: Node) -> void:
	margin.position = Vector2(margin_left, margin_top)
	margin.size = margin.position + Vector2(margin_right, margin_bottom)
	manager = root.manager
	
	if margin_reference: return
	margin_reference = root


func apply(interface: Interface):
	var margin_reference_size: Vector2 = margin_reference.base_rect.size if trim_reference_margin else margin_reference.full_rect.size
	
	interface.base_rect.position = margin.position * margin_reference_size
	interface.full_rect.size = interface.base_rect.size + margin_reference_size * margin.size
	
	for child in interface.filter_children(Interface.ChildFilter.CONTROL):
		child.position = interface.base_rect.position
	
	for child in interface.filter_children(Interface.ChildFilter.INTERFACE):
		if child._margin_adjusted == true: continue
		child.position += interface.base_rect.position
		child._margin_adjusted = true


func _get_update_packet_information(update_packet: InterfaceUpdatePacket):
	for i in 2:
		if update_packet.interface == margin_reference or not (margin.position[i] + margin.size[i]): continue
		if not manager.get_missing_components(margin_reference, [i]): continue
		update_packet.components = SC.erase_array(update_packet.components, [i, i + 2])
