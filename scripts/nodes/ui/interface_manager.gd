class_name InterfaceManager
extends CanvasLayer


var interfaces: Dictionary = {}  ## Stores all [Interface]s this [InterfaceManager] is responsible for, organized by [Menu].
var update_queue: Array[Interface]  ## A list of all [Interface]s this [InterfaceManager] is responsible, in the order they need to update.


func _ready() -> void:
	get_tree().node_added.connect(add_node)
	
	for node in Shcut.get_decendents(self):
		add_node(node)


## If compatible, adds a node to [param interfaces].
func add_node(node: Node) -> void:
	if node is Menu:
		_add_menu(node)
	elif node is Interface:
		_add_interface(node)


## Returns an array of all [Interface]s in the [param interfaces], including [Menu]s.
func get_interfaces_array() -> Array[Interface]:
	return interfaces.keys() + Shcut.merged_nested_arrays(interfaces.values())


#TODO FINISH THIS
## Checks if [param update_queue] has all [param components] for [param interface].
func has_update_packets(interface: Interface, components: Array[int]) -> Array[int]:
	for update_packet in update_queue: for component in components.duplicate():
		if update_packet.interface != interface: continue
		if not update_packet.components.has(component): continue
		components.erase(component)
	
	return components


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


# Checks if [param queue] has all components for each [Interface] in [param interfaces].
func _is_queue_complete() -> bool:
	for interface in get_interfaces_array():
		if not has_update_packets(interface, [0, 1, 2, 3]): return false
	return true
