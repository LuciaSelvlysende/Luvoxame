class_name InventoryAssembler
extends Node


@export var display_index_selection: IndexSelection
@export var slot_index_selection: IndexSelection

var displays: Array[ItemSlotDisplay] = []


func _assemble() -> Array[ItemSlotDisplay]:
	for display_index in displays.size():
		displays[display_index].slot_index = display_index
	
	if not (display_index_selection and slot_index_selection): return displays
	if not display_index_selection.can_map(slot_index_selection): return displays
	
	for display_index in displays.size():
		var display_indicies: Array[int] = display_index_selection.parse()
		var slot_indicies: Array[int] = slot_index_selection.parse()
		
		if not display_indicies.has(display_index): continue
		displays[display_index].slot_index = slot_indicies[display_indicies.find(display_index)]
	
	return displays
