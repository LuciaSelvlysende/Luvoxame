extends Node


const TEMPLATE_ID = "player"
const MIN_INDEX = 0
const MAX_INDEX = 9

var instance: Inventory = Inventories.get_instance(Inventories.create_instance(TEMPLATE_ID))

var selected_index: int = MIN_INDEX:
	set(value): 
		selected_index = Arrays.wrap_index(range(MIN_INDEX, MAX_INDEX), value)

var selected_variant: int:
	set(value):
		var block: Block = get_selected_block()
		selected_variant = Arrays.wrap_index(block.variants, value) if block else 0


func _ready() -> void:
	instance.add_item("dirt", 250)
	instance.add_item("stone", 250)
	instance.add_item("cobblestone", 250)
	instance.add_item("wood_planks", 250)


func _unhandled_input(event: InputEvent) -> void:
	var scroll_direction: int = (
		int(event.is_action_pressed("scroll_forward"))
		- int(event.is_action_pressed("scroll_back"))
	)
	
	if Input.is_action_pressed("cycle_variant"):
		selected_variant += scroll_direction
	else:
		selected_index += scroll_direction
	
	if event.is_action_pressed("slot_1"):
		selected_index = 0
	if event.is_action_pressed("slot_2"):
		selected_index = 1
	if event.is_action_pressed("slot_3"):
		selected_index = 2
	if event.is_action_pressed("slot_4"):
		selected_index = 3
	if event.is_action_pressed("slot_5"):
		selected_index = 4
	if event.is_action_pressed("slot_6"):
		selected_index = 5
	if event.is_action_pressed("slot_7"):
		selected_index = 6
	if event.is_action_pressed("slot_8"):
		selected_index = 7
	if event.is_action_pressed("slot_9"):
		selected_index = 8


func get_selected_slot() -> ItemSlot:
	return instance.get_slot(selected_index)


func get_selected_item() -> Item:
	var selected_slot: ItemSlot = get_selected_slot()
	return selected_slot.item if selected_slot else null


func get_selected_block() -> Block:
	var selected_item: Item = get_selected_item()
	return selected_item.block if selected_item else null


func add_block(block: Block) -> void:
	for item in Items.items.values():
		if item.block != block: continue
		instance.add_item(item)


func remove_block(block: Block) -> void:
	for item in Items.items.values():
		if item.block != block: continue
		if instance.remove_at(selected_index, 1, item): return
		instance.remove_item(item)
