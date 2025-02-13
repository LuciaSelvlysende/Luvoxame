class_name BlockLibrary
extends Resource


@export var blocks: Array[Block]


func prepare() -> void:
	for block in blocks:
		block.prepare()
