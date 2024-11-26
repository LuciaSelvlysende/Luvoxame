class_name BlockLibrary
extends Resource

## A [Resource] that stores [Block]s.


# List of all attributes that a [BlockVariant] can have. Attributes are simple properties that a [BlockVariant] either has, or doesn't have.
enum ATTRIBUTES {
	PARTIAL
}


@export var blocks: Array[Block]  ## Stores all [Block]s in a [BlockLibrary].


## Sets up the [BlockLibrary] to be used.
func prepare() -> void:
	var variants: Array[BlockVariant] = get_all_variants()
	for variant in variants:
		variant._update_rotations()
		variant._generate_collision_shapes()


# BLOCKS ~


## Adds a [Block] to a [BlockLibrary]. If no [Block] is provided, a new one will be created instead. Returns the [Block].
func add_block(block_id: StringName, block: Block = Block.new()) -> Block:
	block.id = block_id
	blocks.append(block)
	
	return block


## Returns a [Block] from a [BlockLibrary]. If there is no [Block] that matches the provided [param id], the function will return a new [Block] instead.
func get_block(block_id: StringName) -> Block:
	for block in blocks:
		if block.id == block_id:
			return block
	
	return Block.new()


## Removes a [Block] from a [BlockLibrary].
func remove_block(id: StringName):
	for block in blocks:
		if block.id == id:
			blocks.erase(block)


## Returns an [Array] of all [Block] [param id]s.
func get_all_block_ids() -> Array[StringName]:
	var block_ids: Array[StringName] = []
	for block in blocks:
		block_ids.append(block.id)
	
	return block_ids


## Returns a [Block] from a [BlockLibrary]. If there is no [Block] that matches the provided [param id], the function will return an empty [Block] instead.
func get_block_from_voxel(voxelID: int) -> Block:
	for block in blocks:
		for variant in block.variants:
			if variant.voxel_ids.has(voxelID):
				return block
	
	return Block.new()


# VARIANTS ~


## Adds a [BlockVariant] to a specified [Block] using the specified [param id]. Returns the [BlockVariant].
func add_variant(block_id: StringName, variant_id: StringName, variant: BlockVariant = BlockVariant.new()) -> BlockVariant:
	var block = get_block(block_id)
	
	return block.add_variant(variant_id, variant)


## Returns a [BlockVariant] of a [Block] in a [BlockLibrary]. If there is no [BlockVariant] that matches the provided [param id], the function will return an empty [BlockVariant] instead.
func get_variant(variant_id: StringName) -> BlockVariant:
	var variants = get_all_variants()
	for variant in variants:
		if variant.id == variant_id:
			return variant
	
	return BlockVariant.new()


## Shortcut function that combines using [param get_block] and accessing [param block.variants].
func get_variants(block_id: StringName) -> Array[BlockVariant]:
	var block: Block = get_block(block_id)
	
	return block.variants


## Returns an array of all [BlockVariant]s of all [Block]s in a [BlockLibrary]. If there are no [BlockVariant]s, the function will return an empty [Array] instead.
func get_all_variants() -> Array[BlockVariant]:
	var variants: Array[BlockVariant] = []
	for block in blocks:
		variants.append_array(block.variants)
	
	return variants


## Returns an array of the [param id]s for all [BlockVariant]s of a [Block]. Returns [code]null[/code] if there the block has no variants.
func get_variant_ids(block_id: StringName) -> Variant:
	var variants = get_variants(block_id)
	
	if variants.size() == 0:
		return null
	
	var variant_ids: Array[StringName] = []
	for variant in variants:
		variant_ids.append(variant.id)
	
	return variant_ids


## Returns an array of the [param id]s for all [BlockVariant]s of all [Block]s.
func get_all_variant_ids() -> Array[StringName]:
	var variants = get_all_variants()
	
	var variant_ids: Array[StringName] = []
	for variant in variants:
		variant_ids.append(variant.id)
	
	return variant_ids


## Returns a [BlockVariant] of a [Block] in a [BlockLibrary]. If there is no [BlockVariant] that matches the provided [param id], the function will return an empty [BlockVariant] instead.
func get_variant_from_voxel(voxelID: int) -> BlockVariant:
	var variants = get_all_variants()
	for variant in variants:
	
		if variant.voxel_ids.has(voxelID):
			return variant
	
	return BlockVariant.new()


## Checks if a [BlockVariant] has the provided [param attribute].
func variant_has_attribute(variant_id: StringName, attribute: ATTRIBUTES) -> bool:
	var variant: BlockVariant = get_variant(variant_id)
	return variant.attributes.has(attribute)


# MISCELLANEOUS ~


## Returns the voxel ids of a [BlockVariant] Shortcut to using [param get_variant_from_voxel] and accessing [param variant.voxel_ids].
func get_voxel_ids(variant_id) -> Array[int]:
	var variant = get_variant(variant_id)
	return variant.voxel_ids


## Returns and [Array] of all [param voxel_ids] of all [BlockVariant]s in a [BlockLibrary].
func get_all_voxel_ids() -> Array[int]:
	var voxel_ids: Array[int] = []
	
	var variants = get_all_variants()
	for variant in variants:
		voxel_ids.append_array(variant.voxel_ids)
	
	return voxel_ids


## Checks if a voxel has the provided [param attribute]. Shortcut to using [param get_variant_from_voxel] and accessing the [BlockVariant]'s [param attributes].
func voxel_has_attribute(voxel_id: int, attribute) -> bool:
	var variant: BlockVariant = get_variant_from_voxel(voxel_id)
	return variant.attributes.has(attribute)


## Returns an [Array] of all [param textures] of all [BlockVariant]s in a [BlockLibrary].
func get_all_textures() -> Array[Image]:
	var textures: Array[Image] = []
	
	for variant in get_all_variants():
		for texture in variant.textures:
			if not textures.has(texture):
				textures.append(texture)
	
	return textures
