class_name Block
extends Resource

## A [Resource] that stores information about a block.


@export var id: StringName  ## The id used to find the block in a [BlockLibrary].
@export var variants: Array[BlockVariant] = []  ## Provides one or more [BlockVariant]'s used by the block.


## Adds a [BlockVariant] to a [Block]. If no [BlockVariant] is provided, a new one will be created instead. Returns the [BlockVariant].
func add_variant(variant_id: StringName, variant: BlockVariant = BlockVariant.new()) -> BlockVariant:
	variant.id = variant_id
	variants.append(variant)
	return variant


## Returns a [BlockVariant] of a [Block]. If there is no [BlockVariant] that matches the provided [param id], the function will return [code]null[/code] instead.
func get_variant(variant_id: StringName) -> BlockVariant:
	for variant in variants:
		if variant.id == variant_id:
			return variant
	return BlockVariant.new()


## Removes a [BlockVariant] from a [Block].
func remove_variant(variant_id: StringName) -> void:
	for variant in variants:
		if variant.id == variant_id:
			variants.erase(variant)
