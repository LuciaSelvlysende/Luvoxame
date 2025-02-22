class_name Inventory
extends Resource


@export var id: StringName
@export var size: int

var instance_id: int
var slots: Array[ItemSlot] = []


func _prepare() -> void:
	slots.clear()
	
	for i in size:
		slots.append(ItemSlot.new())


func add_at(item_id: StringName, slot_index: int, quantity: int) -> int:
	if slot_index >= size: return quantity
	
	var slot: ItemSlot = slots[slot_index]
	return quantity - slot.add(item_id, quantity)


func add_item(item_id: StringName, quantity: int) -> int:
	while quantity > 0:
		var slot: ItemSlot = find_open_slot(item_id)
		if not slot: break
		
		quantity -= slot.add(item_id, quantity)
	
	return quantity


func remove_at(slot_index: int, quantity: int) -> int:
	if slot_index >= size: return quantity
	
	var slot: ItemSlot = slots[slot_index]
	return quantity - slot.remove(quantity)


func remove_item(item_id: StringName, quantity: int = 1) -> int:
	while quantity > 0:
		var slot: ItemSlot = find_item(item_id)
		if not slot: break
		
		quantity -= slot.remove(quantity)
	
	return quantity


func find_item(item_id: StringName) -> ItemSlot:
	for slot in slots:
		if slot.item.id == item_id: return slot
	
	return null


func find_items(item_id: StringName, limit: int = 0x7FFFFFFF) -> Array[ItemSlot]:
	var results: Array[ItemSlot] = []
	
	for slot in slots:
		if results.size() == limit: break
		if not slot.item: continue
		if slot.item.id != item_id: continue
		results.append(slot)
	
	return results


func find_open_slot(item_id: StringName = "") -> ItemSlot:
	if item_id: for slot in slots:
		if not slot.item: continue
		if slot.item.id != item_id: continue
		if not slot.is_full(): return slot
	
	for slot in slots:
		if slot.is_empty(): return slot
	
	return null


func grab_slot(slot_index: int) -> ItemSlot:
	if slot_index >= size: return null
	
	var slot: ItemSlot = slots[slot_index]
	slots[slot_index] = ItemSlot.new()
	return slot


func place_slot(slot_a_index: int, slot_b: ItemSlot) -> ItemSlot:
	if slot_a_index >= size: return null
	
	var slot_a: ItemSlot = slots[slot_a_index]
	
	if slot_a.item == slot_b.item:
		slot_b.quantity -= slot_a.add(slot_b.item.id, slot_b.quantity)
		return slot_b
	else:
		slots[slot_a_index] = slot_b
		return slot_a


func print_inventory() -> void:
	for slot in slots:
		var index: int = slots.find(slot)
		
		if not slot.item:
			print("Slot %s: Empty" % (index + 1))
			continue
		
		print("Slot %s: %s (%s) - %s" % [
			index + 1,
			slot.item.name,
			slot.quantity,
			slot.item.description,
		])


class ItemSlot:
	var item: Item
	var quantity: int
	
	func add(item_id: StringName, add_quantity: int) -> int:
		item = Items.get_item(item_id)
		var accepted_quantity: int = min(add_quantity, item.stack_size - quantity)
		quantity += accepted_quantity
		return accepted_quantity
	
	func remove(remove_quantity: int) -> int:
		var removed_quantity: int = min(remove_quantity, quantity)
		quantity -= removed_quantity
		return removed_quantity
	
	func is_empty() -> bool:
		return not item
	
	func is_full() -> bool:
		if not item: return false
		return quantity == item.stack_size
