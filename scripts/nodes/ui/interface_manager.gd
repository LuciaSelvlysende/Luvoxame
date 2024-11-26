class_name InterfaceManager
extends CanvasLayer


@export var default_window_size: Vector2

var interfaces: Dictionary = {}  ## Stores all [Interface]s this [InterfaceManager] is responsible for, organized by [Menu].
var update_queue: Array[InterfaceUpdatePacket] = []
var window_size: Vector2 = Vector2.ZERO


func _ready() -> void:
	get_tree().node_added.connect(_on_new_node)
	get_viewport().size_changed.connect(update)
	
	for node in Shcut.get_decendents(self):
		add_node(node)
	
	create_update_queue()
	update()


func _on_new_node(node: Node) -> void:
	if not node is Interface: return
	add_node(node)
	create_update_queue()
	update()


## If compatible, adds a node to [param interfaces].
func add_node(node: Node) -> void:
	if not node is Interface: return
	
	if node is Menu:
		_add_menu(node)
	else:
		_add_interface(node)
	
	node.prepare(self)


func create_update_queue() -> void:
	while not _is_queue_complete(): 
		var previous_update_queue: Array[InterfaceUpdatePacket] = update_queue.duplicate()
		
		for interface in get_interfaces_array():
			update_queue.append(_create_update_packet(interface))
			update_queue.erase(null)  # Sometimes an update packet is invalid and returns null.
		
		if update_queue == previous_update_queue: break


## Returns an array of all [Interface]s in the [param interfaces], including [Menu]s.
func get_interfaces_array() -> Array:
	return interfaces.keys() + Shcut.merged_nested_arrays(interfaces.values())


## Checks if [param update_queue] has all [param components] for [param interface].
func get_missing_components(interface: Interface, components: Array[int] = [0, 1, 2, 3]) -> Array[int]:
	for update_packet in update_queue:
		if update_packet.interface != interface: continue
		components = Shcut.erase_array(components, update_packet.components)
	
	return components


func get_packets(interface: Interface, components: Array[int] = [0, 1, 2, 3]) -> Array[InterfaceUpdatePacket]:
	var interface_packets: Array[InterfaceUpdatePacket]
	
	for update_packet in update_queue:
		if update_packet.interface != interface: continue
		if not Shcut.has_array(update_packet.components, components, false): continue
		interface_packets.append(update_packet)
	
	return interface_packets


func update() -> void:
	window_size = get_window().size
	
	for update_packet in update_queue:
		if not update_packet.interface.update_on_window_resize: continue
		update_packet.interface.update()
	
	for interface in get_interfaces_array():
		if not interface.size_reference: continue
		if interface.size_reference.base_size: continue
		interface.size_reference.base_size = interface.size


# Adds an Interface to it's Menu's array of Interfaces in the Interfaces dictionary.
func _add_interface(interface: Interface) -> void:
	for ancestor in Shcut.reversed_array(Shcut.get_ancestors(interface)):
		if not interfaces.keys().has(ancestor) or interfaces[ancestor].has(interface): continue
		interfaces[ancestor].append(interface)


# Adds a menu to the Interfaces dictionary.
func _add_menu(menu: Menu) -> void:
	interfaces[menu] = []
	
	for decendent in Shcut.get_decendents(menu):
		if not decendent is Interface: continue
		interfaces[menu].append(decendent)


func _create_update_packet(interface: Interface) -> InterfaceUpdatePacket:
	var update_packet: InterfaceUpdatePacket = InterfaceUpdatePacket.create(interface, get_missing_components(interface))
	
	if interface.size_reference: 
		interface.size_reference._get_update_packet_information(update_packet)
	if interface.margin:
		interface.margin._get_update_packet_information(update_packet)
	if interface.anchor:
		interface.anchor._get_update_packet_information(update_packet)
		
	for i in 2: for child in interface.filter_children(Interface.ChildFilter.INTERFACE):
		if interface.size_reference and Math.sum_v2_array(Math.abs_v2_array(interface.size_reference.multipliers))[i]: continue
		if not get_missing_components(child, [i, i + 2]): continue
		update_packet.components = Shcut.erase_array(update_packet.components, [i, i + 2])
	
	return update_packet if update_packet.components else null


# Checks if [param queue] has all components for each [Interface] in [param interfaces].
func _is_queue_complete() -> bool:
	for interface in get_interfaces_array():
		if get_missing_components(interface, [0, 1, 2, 3]): return false
	
	return true
