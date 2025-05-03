#class_name InterfaceUpdatePacket
#extends Resource
#
### A small resource that stores information used to determine the update order of [Interface]s.
###
### [InterfaceUpdatePacket]s are stored in [member InterfaceManager.update_queue]. When [InterfaceManager]
### updates the [Interface]s it is responsible for, it loops through the update queue, and updates the
### interface specified by the update packet. Each update packet corresponds with only a single [Interface],
### but a single Interface may have multiple update packets. Update packets store "[member components]",
### which is an Array of ints that correspond to particular properties, specifically size and position.
### There are four components, 0, 1, 2, and 3, which correspond with [code]size.x[/code], [code]size.y[/code], 
### [code]position.x[/code], and [code]position.y[/code]. In order to be considered fully updated, an
### Interface must update each component.
#
#
#var interface: Interface  ## The [Interface] specififed by this update packet.
#var components: Array[int]  ## The components (see the [InterfaceUpdatePacket] description) that are considered updated once this update packet used.
#
#
### Creates a functional [InterfaceUpdatePacket]. Update packets created with [method Object.new] will not be functional.
#static func create(interface: Interface, components: Array[int]) -> InterfaceUpdatePacket:
	#var update_packet: InterfaceUpdatePacket = InterfaceUpdatePacket.new()
	#update_packet.interface = interface
	#update_packet.components = components
	#return update_packet
