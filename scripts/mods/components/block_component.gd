class_name BlockComponent
extends ModComponent


@export var block: Block


func _load_component() -> Error:
	return VoxelAssets.add_block(block)
