extends Node


var interfaces: Array[Interface] = []
var update_queue: Array[InterfaceUpdatePacket]


func _ready():
	get_tree().root.ready.connect(_on_scene_ready)
	get_viewport().size_changed.connect(_on_screen_size_change)


func _on_scene_ready():
	get_update_queue()
	update()


func _on_screen_size_change():
	update()


func add_interface(interface: Interface) -> void:
	interfaces.append(interface)
	interface.prepare()
	
	if get_tree().root.is_node_ready():
		get_update_queue()
		update()


func get_update_queue() -> void:
	while not has_all_update_packets(): 
		var last_update_queue: Array[InterfaceUpdatePacket] = update_queue.duplicate()
		
		for interface in interfaces:
			update_queue.append(get_update_packet(interface))
			update_queue.erase(null)  # Sometimes an update packet is invalid and returns null.
		
		if update_queue == last_update_queue: 
			break


func print_queue() -> void:
	for update_packet in update_queue:
		printt(update_packet.components, update_packet.interface.name)


func get_interface_packets(interface: Interface, components: Array[int] = [0, 1, 2, 3]) -> Array[InterfaceUpdatePacket]:
	var interface_packets: Array[InterfaceUpdatePacket]
	
	for update_packet in update_queue:
		if update_packet.interface != interface: continue
		if not Shcut.has_array(update_packet.components, components, false): continue
		interface_packets.append(update_packet)
	
	return interface_packets


func get_missing_components(interface: Interface) -> Array[int]:
	var components: Array[int] = [0, 1, 2, 3]
	
	for component in components.duplicate():
		if has_update_packets(interface, [component]):
			components.erase(component)
	
	return components


func get_update_packet(interface: Interface) -> InterfaceUpdatePacket:
	var update_packet: InterfaceUpdatePacket = InterfaceUpdatePacket.create(interface, get_missing_components(interface), [])
	
	if interface.size_reference: 
		interface.size_reference._get_update_packet_information(update_packet)
	if interface.margin:
		interface.margin._get_update_packet_information(update_packet)
	if interface.anchor:
		interface.anchor._get_update_packet_information(update_packet)
	
	for i in 2: for child in interface.filter_children(Interface.ChildFilter.INTERFACE):
		if interface.size_reference and Math.sum_v2_array(Math.abs_v2_array(interface.size_reference.multipliers))[i]: continue
		if has_update_packets(child, [i]):
			update_packet.dependencies.append_array(get_interface_packets(child, [i]))
		else:
			update_packet.components = Shcut.erase_array(update_packet.components, [i, i + 2])
	
	return update_packet if update_packet.components else null


# *
func has_update_packets(interface: Interface, components: Array[int]) -> bool:
	for update_packet in update_queue: 
		if update_packet.interface != interface: continue
		
		for component in components.duplicate():
			if not update_packet.components.has(component): continue
			components.erase(component)
	
	return not components

# *
func has_all_update_packets() -> bool:
	for interface in interfaces:
		if not has_update_packets(interface, [0, 1, 2, 3]): return false
	return true


#func merge_update_packets(interface_packets: Array[InterfaceUpdatePacket]) -> void:
	#for interface_packet in interface_packets: 
		#if interface_packet == interface_packets.front(): continue
		#
		#for update_packet in update_queue:
			#if update_packet.has_dependency(interface_packet): break
			#if update_packet != interface_packet: continue
			#
			#var index: int = interface_packets.find(interface_packet)
			#update_queue.erase(interface_packets[index - 1])
			#interface_packet.components += interface_packets[index - 1].components


func update() -> void:
	for update_packet in update_queue:
		update_packet.interface.update()
	
	for interface in interfaces:
		if not interface.size_reference: continue
		if interface.size_reference.base_size: continue
		interface.size_reference.base_size = interface.size_reference.get_size()


# For whatever reason, updating all Interfaces is more preformant than using this function to selectively update Interfaces.
# This should probably be revisited in the future.

#func update_branch(interface: Interface) -> void:
	#var interface_packets: Array[InterfaceUpdatePacket] = []
	#
	#for update_packet in update_queue:
		#if update_packet.interface != interface: continue
		#interface_packets.append(update_packet)
	#
	#for update_packet in update_queue:
		#if interface_packets.has(update_packet):
			#update_packet.interface.update()
		#if update_packet.has_dependencies(interface_packets):
			#update_packet.interface.update()
