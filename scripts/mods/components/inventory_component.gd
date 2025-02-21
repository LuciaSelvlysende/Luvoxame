class_name InventoryComponent
extends ModComponent


@export var inventory: Inventory


func _load_component() -> Error:
	return Items.add_inventory(inventory)
