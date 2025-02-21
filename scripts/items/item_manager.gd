class_name Items
extends Node


static var default_stack_size: int = 1000
static var items: Array[Item] = []
static var inventories: Array[Inventory] = []
static var inventory_instances: Array[Inventory] = []
static var instance_ids: Dictionary = {}  # Dictionary[int (id), StringName (file path)]


func _ready() -> void:
	for item in items:
		if item.stack_size: continue
		item.stack_size = default_stack_size


static func add_inventory(inventory: Inventory) -> Error:
	if get_inventory(inventory.id): return ERR_ALREADY_EXISTS
	inventories.append(inventory)
	return OK


static func get_inventory(id: Variant) -> Inventory:
	if not [TYPE_STRING, TYPE_STRING_NAME, TYPE_INT].has(typeof(id)): return null
	
	match typeof(id):
		TYPE_STRING, TYPE_STRING_NAME:
			for inventory in inventories:
				if inventory.id == id: return inventory
		TYPE_INT:
			for inventory_instance in inventory_instances:
				if inventory_instance.instance_id == id: return inventory_instance
	
	return null


static func create_inventory(id: StringName) -> int:
	var inventory: Inventory = get_inventory(id)
	if not inventory: return -1
	
	var instance: Inventory = inventory.duplicate(true)
	instance._prepare()
	
	while not instance_ids.keys().has(instance.instance_id):
		instance.instance_id = randi()
		instance_ids[instance.instance_id] = ""
	
	inventory_instances.append(instance)
	return instance.instance_id


static func add_item(item: Item) -> Error:
	if get_item(item.id): return ERR_ALREADY_EXISTS
	items.append(item)
	return OK


static func get_item(id: StringName) -> Item:
	for item in items:
		if item.id == id: return item
	
	return null
