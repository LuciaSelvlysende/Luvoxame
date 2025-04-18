class_name ItemSlot
extends Resource

## A Resource that stores a single Item.
##
## [b]See also:[/b] [Item], [Inventory]. [br][br]
##
## [b]Note:[/b] Many methods take an [param item] parameter. This is passed to [method ItemManager.ensure_item] and can
## be [code]null[/code], an [Item], a [String], or a [StringName].

# Dependencies (Required):      Dependencies (Suggested):
# - Item (Luvoxame)             - Inventory (Luvoxame)

# To-do List
# - Maybe add support for negative quantities in methods like remove() or add()?


## Emitted when either the [member item] or [member quantity] of the ItemSlot is changed.
signal content_changed

## The index in [member Inventory.slots] where the ItemSlot resides,
## or [code]-1[/code] if the ItemSlot is not part of an inventory.
var index: int = -1
## The [Item] that the ItemSlot currently holds. Do NOT set directly, use [method set_content] instead.
var item: Item
## The number of "items" (in the gameplay sense) that the ItemSlot
## contains. Do NOT set directly, use [method set_content] instead.
var quantity: int


func _init(init_item: Item = null, init_quantity: int = 0) -> void:
	item = init_item
	quantity = init_quantity


static func create_copy(copy_slot: ItemSlot) -> ItemSlot:
	return ItemSlot.new(copy_slot.item, copy_slot.quantity)


func set_content(set_item: Variant, set_quantity: int, require_match: bool = false) -> int:
	set_item = Items.ensure_item(set_item)
	if require_match and item and set_item != item: return 0
	var previous_quantity: int = quantity
	item = set_item if max(set_quantity, 0) else null
	quantity = clamp(set_quantity, 0, item.stack_size if item else 0)
	content_changed.emit()
	return quantity - previous_quantity


## Increases [member quantity] by [param add_quantity], up to [member Item.stack_size] of [member item]. If
## [param add_item] is provided, [member item] will be changed to match. If [param require_match] is [code]true[/code],
## and [param add_item] does not match [member item], nothing will happen. Returns the quantity that was successfully added.
func add(add_item: Variant = null, add_quantity: int = 1, require_match: bool = false) -> int:
	add_item = Items.ensure_item(add_item) if Items.ensure_item(add_item) else item
	return set_content(add_item, (quantity if add_item == item else 0) + add_quantity, require_match)


## Works the same as [method add], but sets [member quantity] to [member Item.stack_size] of [member item].
func add_all(add_item: Variant = null, require_match: bool = false) -> int:
	add_item = Items.ensure_item(add_item) if Items.ensure_item(add_item) else item
	return set_content(add_item, add_item.stack_size if add_item else 0, require_match)


## Decreases [member quantity] by [param remove_quantity], but not lower than [code]zero[/code]. If [param match_item] is provided
## and [member item] does not match [param match_item], nothing will happen. Returns the quantity that was successfully removed.
func remove(remove_item: Variant = null, remove_quantity: int = 1, require_match: bool = true) -> int:
	remove_item = Items.ensure_item(remove_item) if remove_item else item
	return set_content(remove_item, quantity - remove_quantity, require_match)


## Works the same as [method remove], but sets [member quantity] to [code]zero[/code].
func remove_all(remove_item: Variant = null, require_match: bool = true) -> int:
	remove_item = Items.ensure_item(remove_item) if remove_item else item
	return set_content(remove_item, 0, require_match)


## Copies the [member item] and [member quantity] from [param copy_slot]. 
## First clears [code]self[/code] if [param clear] is [code]true[/code].
func copy(copy_slot: ItemSlot, clear: bool = true, require_match: bool = false) -> void:
	if clear:
		self.set_content(null, 0)
	
	self.set_content(copy_slot.item, copy_slot.quantity, require_match)


## Adds [member quantity] from [param merge_slot] to the ItemSlot, replacing [member item]
## with that of [param merge_slot] if they don't match. If require match is [code]true[/code]
## and [member item] does not match that of [param merge_slot], nothing will happen.
func merge(merge_slot: ItemSlot, require_match: bool = false) -> void:
	if self.is_empty() or merge_slot.is_empty() or self.item == merge_slot.item:
		merge_slot.remove(null, self.add(merge_slot.item, merge_slot.quantity))
		return
	
	if require_match: return
	
	var interim_slot: ItemSlot = ItemSlot.create_copy(self)
	self.copy(merge_slot)
	merge_slot.copy(interim_slot)


## Shortcut for [code]not item_slot.item[/code] to improve readability.
func is_empty() -> bool:
	return not item


## Returns [code]true[/code] if [member quantity] is equal to [member Item.stack_size] of [member item].
func is_full() -> bool:
	if not item: return false
	return quantity == item.stack_size
