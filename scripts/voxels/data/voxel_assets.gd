class_name VoxelAssets
extends RefCounted


const AIR: int = 0

static var block_library: BlockLibrary
static var voxel_atlas: Image
static var voxel_library: VoxelBlockyLibrary
static var voxel_material: StandardMaterial3D


static func prepare() -> void:
	block_library = load("uid://qng2hx01nyki")
	block_library.prepare()
	
	voxel_atlas = _create_atlas()
	voxel_library = _create_library()
	
	voxel_material = load("uid://bl8pu4arv3vjc")
	voxel_material.albedo_texture = ImageTexture.create_from_image(voxel_atlas)


## Creates a [VoxelAtlas] containing all textures used in [param block_library].
static func _create_atlas() -> Image:
	var textures: Dictionary = _get_textures(block_library)
	var atlas_size: Vector2i = _get_atlas_size(textures)
	var voxel_atlas: Image = Image.create_empty(atlas_size.x, atlas_size.y, false, Image.FORMAT_RGBA8)
	
	var atlas_position: Vector2i = Vector2i.ZERO
	
	for texture_size in textures.keys():
		for texture in textures[texture_size]:
			voxel_atlas.blit_rect(texture, Rect2i(Vector2i.ZERO, texture_size), atlas_position)
			_record_texture_rect(block_library, texture, Rect2i(atlas_position, texture_size))
			atlas_position.x += texture_size.x
		
		atlas_position.x = 0
		atlas_position.y += texture_size.y
	
	return voxel_atlas


## Creates a [VoxelLibrary] using [Block]s from [block_library].
static func _create_library() -> VoxelBlockyLibrary:
	var voxel_library: VoxelBlockyLibrary = VoxelBlockyLibrary.new()
	
	# Add air.
	voxel_library.add_model(VoxelBlockyModelEmpty.new())
	
	# Add blocks.
	for block in block_library.blocks:
		block.mesh = _adjust_uv_coordinates(block.mesh, block.texture_rects.front())
		
		for rotation in block.rotations:
			voxel_library.add_model(VoxelType.create(block, rotation))
	
	voxel_library.bake()
	return voxel_library


# Helper function for _create_library(). Adjusts UV coordinates for each surface of a mesh to match the location of the model's texture in the atlas.
static func _adjust_uv_coordinates(mesh: Mesh, texture_rect: Rect2i) -> Mesh:
	var adjusted_mesh = ArrayMesh.new()
	var surface = mesh.get_surface_count() - 1
	
	while surface > -1:
		var vertex_array = mesh.surface_get_arrays(surface)
		var uv_array_texture = vertex_array[Mesh.ARRAY_TEX_UV]
		var uv_array_atlas = PackedVector2Array()
		
		for uv in uv_array_texture:
			var position: Vector2 = Vector2(texture_rect.position) / Vector2(VoxelAssets.voxel_atlas.get_size())
			var size: Vector2 = uv * (Vector2(texture_rect.size) / Vector2(VoxelAssets.voxel_atlas.get_size()))
			uv_array_atlas.append(position + size)
			
		vertex_array[Mesh.ARRAY_TEX_UV] = uv_array_atlas
		adjusted_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, vertex_array)
		surface -= 1
	
	return adjusted_mesh


# Helper function for _create_atlas(), determines the appropriate size for the atlas.
static func _get_atlas_size(textures: Dictionary) -> Vector2i:
	var atlas_size: Vector2i = Vector2i(0, Vectors.sum_array(textures.keys()).y)
	
	for texture_size in textures.keys():
		var width_candidate: int = texture_size.x * textures[texture_size].size()
		if width_candidate > atlas_size.x:
			atlas_size.x = width_candidate
	
	return atlas_size


# Helper function for _create_atlas(). Returns a dictionary of all textures used in [param block_library], sorted by size.
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


# Helper function for _create_atlas(). Records the Rect2i that contains [param texture] for each block that uses [param texture].
static func _record_texture_rect(block_library: BlockLibrary, texture: Image, rect: Rect2i) -> void:	
	for block in block_library.blocks:
		if not block.textures.has(texture): continue
		var index: int = block.textures.find(texture)
		block.texture_rects[index] = rect
