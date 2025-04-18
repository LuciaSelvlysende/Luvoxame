class_name Inventory
extends Resource

## A Resource that stores Items.
##
## [b]See also:[/b] [InventoryManager], [ItemSlot]. [br][br]
##
## [Inventory] is a class that stores [Item]s in an array of [ItemSlot]s, and provides a variety of methods to interact
## with the contents of those ItemSlots. Inventories are used in two contexts: as templates, and as instances. You can
## add an Inventory template to [InventoryManager] by calling [method InventoryManager.add_template]. Then, you can
## create an instance of that Inventory by calling [method InventoryManager.create_instance]. This will return an ID
## associated with that instance (not an Inventory resource). This is what should be stored when saving game data. In
## order to access that instance, call [method InventoryManager.get_instance]. [br][br]
##
## [b]Note:[/b] Many methods take an [param item] parameter. This is passed to [method ItemManager.ensure_item] and can
## be [code]null[/code], an [Item], a [String], or a [StringName].

# Dependencies (Required):              Dependencies (Suggested):
# - Arrays (Lucia's Utilities)          - InventoryManager (Luvoxame)
# - ItemManager (Luvoxame)
# - ItemSlot (Luvoxame)

# To-do List:
# - Add find_open_slots() method. 
# - Add properties property.


## An ID used to access an Inventory template using [method InventoryManager.get_template].
@export var id: StringName
## Defines how many [ItemSlot]s are part of the Inventory.
@export var size: int

## An ID used to access an Inventory instance using [method InventoryManager.get_instance].
var instance_id: int
## Array of [ItemSlot]s used to store the contents of an Inventory.
var slots: Array[ItemSlot] = [] 


# Object._init cannot be used since @export variables update after Object._init.
# Called when instances are created via InventoryManager.create_instance(). 
func _prepare() -> void:
	slots.resize(size)
	Arrays.fill_unique(slots, ItemSlot.new())
	
	for index in slots.size():
		slots[index].index = index


## Calls [method ItemSlot.add] on the [ItemSlot] at [param index] in [member slots].
## Returns the quantity that was successfully added to the ItemSlot.
func add_at(index: int, item = null, quantity: int = 1, require_match: bool = false) -> int:
	if index >= size: return quantity
	return slots[index].add(item, quantity, require_match)


## Loops over open [member slots] (see [method find_open_slot]), calling [method ItemSlot.add] until [param quantity]
## has been added or no more open slots can be found. Returns the total quantity that was successfully added.
func add_item(item, quantity: int = 1) -> int:
	while quantity > 0:
		var slot: ItemSlot = find_open_slot(item)
		if not slot: break
		quantity -= slot.add(item, quantity)
	
	return quantity


## Calls [method ItemSlot.remove] for the [ItemSlot] at [param index] in [member slots].
## Returns the quantity that was successfully removed from the ItemSlot.
func remove_at(index: int, quantity: int = 1, match_item = null) -> int:
	if index >= size: return quantity
	return slots[index].remove(match_item, quantity)


## Loops over [member slots] containing [param item] (see [method find_item]), calling
## [method ItemSlot.remove] until [param quantity] has been removed or no more slots containing
## [param item] can be found. Returns the total quantity that was successfully removed.
func remove_item(item, quantity: int = 1) -> int:
	while quantity > 0:
		var slot: ItemSlot = find_item(item)
		if not slot: break
		quantity += slot.remove(null, quantity)
	
	return quantity


## Returns the first [ItemSlot] in [member slots] that contains [param item].
## Returns [code]null[/code] if the item is not found.
func find_item(item) -> ItemSlot:
	item = Items.ensure_item(item)
	
	for slot in slots:
		if slot.item and slot.item == item: return slot
	
	return null


## Returns an array of all [ItemSlot]s in [member slots] that contains [param item].
func find_items(item, limit: int = 0x7FFFFFFF) -> Array[ItemSlot]:
	item = Items.ensure_item(item)
	var results: Array[ItemSlot] = []
	
	for slot in slots:
		if results.size() == limit: break
		if not slot.item: continue
		if slot.item != item: continue
		results.append(slot)
	
	return results


## Returns the first [ItemSlot] in [member slots] that has room to increase it's quantity. If [param item]
## is provided, only empty slots or slots containing that [param item] will be considered.
func find_open_slot(item = null) -> ItemSlot:
	item = Items.ensure_item(item)
	
	if item: for slot in slots:
		if not slot.item: continue
		if slot.item != item: continue
		if not slot.is_full(): return slot
	
	for slot in slots:
		if slot.is_empty(): return slot
	
	return null


## Returns the [ItemSlot] at [param index] in [member slots], or [code]null[/code] if [index] is out of bounds.
func get_slot(index: int) -> ItemSlot:
	if index >= size: return null
	return slots[index]


## Prints the contents of the Inventory by calling [member print_slot] for 
## each [ItemSlot] in [member slots]. Useful for debugging.
func print_inventory() -> void:
	for index in slots.size():
		print_slot(index)


## Prints the [member Item.name], [member ItemSlot.quantity], and [member Item.description]
## for each [ItemSlot] in [member slots]. Useful for debugging.
func print_slot(index: int) -> void:
	var slot: ItemSlot = slots[index]
	
	if not slot.item:
		print("Slot %s: Empty" % (index + 1))
		return
	
	print("Slot %s: %s (%s) - %s" % [
		index + 1,
		slot.item.name,
		slot.quantity,
		slot.item.description,
	])
