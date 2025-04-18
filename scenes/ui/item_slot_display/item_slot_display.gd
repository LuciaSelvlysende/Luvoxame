class_name ItemSlotDisplay
extends Button


signal slot_pressed(slot: ItemSlot)

@export var texture_rect: TextureRect
@export var quantity_label: Label

var slot_index: int
var slot: ItemSlot:
	set(value):
		if slot: slot.content_changed.disconnect(_on_content_changed)
		slot = value
		if slot: slot.content_changed.connect(_on_content_changed)
		_on_content_changed()


static func create(init_position: Vector2, init_size: Vector2) -> ItemSlotDisplay:
	var slot_display: ItemSlotDisplay = load("uid://c0x2ybi80je2d").instantiate()
	
	slot_display.position = init_position
	slot_display.size = init_size
	
	return slot_display


func _on_resized() -> void:
	texture_rect.size = size
	quantity_label.size = Vector2(size.x * 0.9375, size.y)
	@warning_ignore("narrowing_conversion")
	quantity_label.label_settings.font_size = size.x / 3.0


func _on_pressed() -> void:
	slot_pressed.emit(slot)


func _on_content_changed() -> void:
	if slot.item:
		texture_rect.texture = slot.item.texture
		quantity_label.text = str(slot.quantity)
		tooltip_text = slot.item.name + "\n" + slot.item.description
	else:
		texture_rect.texture = null
		quantity_label.text = ""
