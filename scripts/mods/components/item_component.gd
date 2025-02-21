class_name ItemComponent
extends ModComponent


@export var item: Item


func _load_component() -> Error:
	return Items.add_item(item)
