extends CanvasLayer


@onready var inventory: InventoryMenu = %Inventory
@onready var held_slot_display: ItemSlotDisplay = %HeldSlotDisplay


func _ready() -> void:
	held_slot_display.slot = ItemSlot.new()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			inventory.hide()
	
	if event.is_action_pressed("inventory"):
		inventory.visible = not inventory.visible
		get_tree().paused = inventory.visible
	
	Input.mouse_mode = (
		Input.MOUSE_MODE_VISIBLE
		if get_tree().paused
		else Input.MOUSE_MODE_CAPTURED
		)
