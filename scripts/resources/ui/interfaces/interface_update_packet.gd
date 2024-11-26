class_name InterfaceUpdatePacket
extends Resource


var interface: Interface
var components: Array[int]
var dependencies: Array[InterfaceUpdatePacket]


@warning_ignore("shadowed_variable")
static func create(interface: Interface, components: Array[int], dependencies: Array[InterfaceUpdatePacket] = []) -> InterfaceUpdatePacket:
	var update_packet: InterfaceUpdatePacket = InterfaceUpdatePacket.new()
	update_packet.interface = interface
	update_packet.components = components
	update_packet.dependencies = dependencies
	return update_packet
