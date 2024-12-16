class_name InterfaceManager
extends CanvasLayer

## Node that handles the updating of all [Interface] decedents.
##
## [Interface]s require an InterfaceManager to update them, and currently, also require a [Menu].
## Support for Interfaces outside of [Menu]'s is planned, but has not been implemented yet. [br][br]
##
## To use an InterfaceManager, ensure that [Interface]s are arranged as decendents such that they meet
## the requirements outlined above and set [member default_window_size] to the window size you are designing
## at. After that, the InterfaceManager will, for the most part, take care of things, though you may
## want to call [method update] if it is not already being called automatically.


@export var default_window_size: Vector2 = Vector2(1152, 648)  ## The window size that UI is designed for. Window scale is based on this.
@export var min_window_size: Vector2 = Vector2.ZERO  ## Sets [member Window.min_size].

var interfaces: Array[Interface]
var update_queue: Array[InterfaceUpdatePacket] = []  ## Stores the order in which Interfaces should update.
var window_size: Vector2 = Vector2.ZERO  ## The current window size, equal to [member Window.size].

@onready var window: Window = get_window()  ## The window that the InterfaceManager is on.


func _ready() -> void:
	for i in 2: if min_window_size[i] > window.min_size[i]:
		window.min_size[i] = min_window_size[i] as int
	
	get_tree().node_added.connect(_on_new_node)
	get_viewport().size_changed.connect(update)
	
	for node in SC.get_decendents(self):
		if not node is Interface: continue
		interfaces.append(node)
		node.prepare(self)
	
	prepare()


func _on_new_node(node: Node) -> void:
	if not node is Interface: return
	interfaces.append(node)
	node.prepare(self)
	prepare()


## Addes [InterfaceUpdatePacket]s to [member update_queue] in the right order. 
func create_update_queue() -> void:
	while not _is_queue_complete(): 
		var previous_update_queue: Array[InterfaceUpdatePacket] = update_queue.duplicate()
		
		for interface in interfaces:
			update_queue.append(_create_update_packet(interface))
			update_queue.erase(null)  # Sometimes an update packet is invalid and returns null.
		
		if update_queue == previous_update_queue: break  # Prevents infinite loops.


## Checks if [member update_queue] has all [param components] for [param interface].
func get_missing_components(interface: Interface, components: Array[int] = [0, 1, 2, 3]) -> Array[int]:
	for update_packet in update_queue:
		if update_packet.interface != interface: continue
		components = SC.erase_array(components, update_packet.components)
	
	return components


## Returns all [InterfaceUpdatePacket]s for the provided [param interface] that contain any of the components specified by the provided [param components].
func get_packets(interface: Interface, components: Array[int] = [0, 1, 2, 3]) -> Array[InterfaceUpdatePacket]:
	var interface_packets: Array[InterfaceUpdatePacket]
	
	for update_packet in update_queue:
		if update_packet.interface != interface: continue
		if not SC.has_array(update_packet.components, components, false): continue
		interface_packets.append(update_packet)
	
	return interface_packets


## Sets up the InterfaceManager. Should be called at the start of the game and when a new Interface is added.
func prepare() -> void:
	create_update_queue()
	update([], default_window_size)  # Interfaces need to update at the default window size once to be fully set up.
	update()


## Updates all [Interface]s that the InterfaceManager is responsible for.
func update(target_interfaces: Array[Interface] = [], override_window_size: Vector2 = Vector2.ZERO) -> void:
	window_size = override_window_size if override_window_size else window.size 
	
	for update_packet in update_queue:
		if target_interfaces and not target_interfaces.has(update_packet.interface): continue
		update_packet.interface.update()
	
	# Set base_size for size references. While this isn't an intuitive place to
	# do it, this seems to be the best option.
	for interface in interfaces:
		if not interface.size_reference: continue
		if interface.size_reference.base_size: continue
		interface.size_reference.base_size = interface.size


# Helper function for create_update_queue().
func _create_update_packet(interface: Interface) -> InterfaceUpdatePacket:
	var update_packet: InterfaceUpdatePacket = InterfaceUpdatePacket.create(interface, get_missing_components(interface))
	
	if interface.size_reference: 
		interface.size_reference._get_update_packet_information(update_packet)
	if interface.margin:
		interface.margin._get_update_packet_information(update_packet)
	if interface.anchor:
		interface.anchor._get_update_packet_information(update_packet)
	
	for i in 2: for child in interface.filter_children(Interface.ChildFilter.INTERFACE):
		# The multiple operations on size_reference.multipliers is to convert it to a boolean.
		if interface.size_reference and Vectors.sum_array(Vectors.abs_array(interface.size_reference.multipliers))[i]: continue
		if interface.size_override[i]: continue
		if not get_missing_components(child, [i, i + 2]): continue
		update_packet.components = SC.erase_array(update_packet.components, [i, i + 2])
	
	return update_packet if update_packet.components else null


# Helper function for create_update_queue().
func _is_queue_complete() -> bool:
	for interface in interfaces:
		if get_missing_components(interface, [0, 1, 2, 3]): return false
	
	return true
