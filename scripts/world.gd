extends Node3D


var player_inventory: Inventory


func _ready() -> void:
	player_inventory = Items.get_inventory(Items.create_inventory("player"))
	player_inventory.add_at("stick", 6, 54)
	player_inventory.add_item("iron_ingot", 5)


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("inventory"): return
	
	print("Player Inventory:")
	player_inventory.print_inventory()
	print()
