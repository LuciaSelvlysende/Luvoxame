class_name InventoryMenu
extends Control


@export var assembler: InventoryAssembler
@export var show_held_slot: bool = true

var instance: Inventory
var slot_displays: Array[ItemSlotDisplay] = []

@onready var held_slot: ItemSlotDisplay = %HeldSlotDisplay


func _ready() -> void:
	slot_displays = assembler._assemble()
	
	for slot_display in slot_displays:
		slot_display.slot_pressed.connect(_on_slot_press)
		slot_display.slot = instance.get_slot(slot_display.slot_index)


func _process(_delta) -> void:
	if not (visible and show_held_slot): return
	held_slot.global_position = get_tree().root.get_mouse_position() - held_slot.size / 2


func _on_slot_press(slot: ItemSlot) -> void:
	(slot if held_slot.slot.item else held_slot.slot).merge(held_slot.slot if held_slot.slot.item else slot)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN if held_slot.slot.item else Input.MOUSE_MODE_VISIBLE
