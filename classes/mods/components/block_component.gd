class_name BlockComponent
extends ModComponent


@export var block: Block


func _load_component() -> Error:
	return Blocks.add_block(block)
