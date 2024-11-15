class_name InterfaceUpdatePacket
extends Resource


var interface: Interface
var components: Array[int]
var dependencies: Array[InterfaceUpdatePacket]


@warning_ignore("shadowed_variable")
static func create(interface: Interface, components: Array[int], dependencies: Array[InterfaceUpdatePacket]) -> InterfaceUpdatePacket:
	var update_packet: InterfaceUpdatePacket = InterfaceUpdatePacket.new()
	update_packet.interface = interface
	update_packet.components = components
	update_packet.dependencies = dependencies
	return update_packet


func has_dependency(update_packet: InterfaceUpdatePacket) -> bool:
	for dependency in dependencies:
		if dependency == update_packet: return true
		if dependency.has_dependency(update_packet): return true
	return false


func has_dependencies(update_packets: Array[InterfaceUpdatePacket]) -> bool:
	for update_packet in update_packets:
		if has_dependency(update_packet): return true
	return false
