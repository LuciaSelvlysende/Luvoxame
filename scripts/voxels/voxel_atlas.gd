class_name VoxelAtlas
extends Image


## Creates a [VoxelAtlas] containing all textures used in [param block_library].
static func create_atlas(block_library: BlockLibrary) -> Image:
	var textures: Dictionary = _get_textures(block_library)
	var atlas_size: Vector2i = _get_atlas_size(textures)
	var voxel_atlas: VoxelAtlas = VoxelAtlas.create_empty(atlas_size.x, atlas_size.y, false, Image.FORMAT_RGBA8)
	
	# Prepare blocks to store the location of their textures on the VoxelAtlas.
	for block in block_library.blocks:
		block.texture_rects.resize(block.textures.size())
	
	var atlas_position: Vector2i = Vector2i.ZERO
	
	for texture_size in textures.keys():
		for texture in textures[texture_size]:
			voxel_atlas.blit_rect(texture, Rect2i(Vector2i.ZERO, texture_size), atlas_position)
			_record_texture_rect(block_library, texture, atlas_position)
			atlas_position.x += texture_size.x
			
			atlas_position.x = 0
			atlas_position.y += texture_size.y
	
	return voxel_atlas


# Helper function for create_atlas(), determines the appropriate size for the atlas.
static func _get_atlas_size(textures: Dictionary) -> Vector2i:
	var atlas_size: Vector2i = Vector2i(0, Vectors.sum_array(textures.keys()).y)
	for texture_size in textures.keys():
		var width_candidate: int = texture_size.x * textures[texture_size].get_size().x
		if width_candidate > atlas_size.x:
			atlas_size.x = width_candidate
	
	return atlas_size


# Helper function for create_atlas(). Returns a dictionary of all textures used in [param block_library], sorted by size.
static func _get_textures(block_library: BlockLibrary) -> Dictionary:
	var unsorted_textures: Array[Image] = []
	var sorted_textures: Dictionary = {}  # Dictionary[Vector2i, Array[Image]]
	
	for block in block_library.blocks: for texture in block.textures:
		if unsorted_textures.has(texture): continue
		unsorted_textures.append(texture)
	
	for texture in unsorted_textures:
		if not sorted_textures.has(texture.get_size()):
			sorted_textures[texture.get_size()] = []
		
		sorted_textures[texture.get_size()].append(texture)
	
	return sorted_textures


# Helper function for create_atlas(). Records the Rect2i that contains [param texture] for each block that uses [param texture].
static func _record_texture_rect(block_library: BlockLibrary, texture: Image, position: Vector2i) -> void:
	for block in block_library.blocks:
		if not block.textures.has(texture): continue
		block.texture_rects[block.textures.append]
