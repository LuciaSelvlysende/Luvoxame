class_name InventoryNodeReader
extends InventoryAssembler


@export var root_nodes: Array[Node]


func _assemble() -> Array[ItemSlotDisplay]:
	for root_node in root_nodes: for decendent in SC.get_decendents(root_node):
		if not decendent is ItemSlotDisplay: continue
		displays.append(decendent)
	
	return super()
