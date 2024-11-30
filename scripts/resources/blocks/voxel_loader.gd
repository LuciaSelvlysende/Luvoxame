class_name VoxelLoader
extends Resource

## Tool to create assets required by a VoxelTerrain node.


## Creates all voxel assets.
static func create_all_voxel_assets(block_library: BlockLibrary) -> VoxelAssets:
	var voxel_assets = VoxelAssets.new()
	
	voxel_assets.atlas_image = create_atlas_image(block_library)
	voxel_assets.voxel_material = create_voxel_material(voxel_assets.atlas_image)
	voxel_assets.voxel_library = create_voxel_library(block_library)
	voxel_assets.voxel_mesher = VoxelMesherBlocky.new()
	voxel_assets.voxel_mesher.library = voxel_assets.voxel_library
	
	return voxel_assets


## Creates an [Image] from individual textures that can be used as an atlas. Also stores the location of each texture in the atlas in the [Block]'s properties.
static func create_atlas_image(block_library: BlockLibrary) -> Image:
	var atlas_size: Vector2i = _get_atlas_size(block_library) * 16
	var atlas_image: Image = Image.create(atlas_size.x, atlas_size.y, false, Image.FORMAT_RGBA8)
	
	var textures: Array[Image] = block_library.get_all_textures()
	var atlas_position: int = 0
	
	for texture in textures:
		atlas_image.blit_rect(texture, Rect2i(0, 0, texture.get_width(), texture.get_height()), Vector2i(atlas_position, 0))
		atlas_position += 16
	
	var variants = block_library.get_all_variants()
	
	for variant in variants:
		for texture in variant.textures:
			variant.atlas_positions.append(textures.find(texture))
	
	return atlas_image


## Creates a [StandardMaterial3D] that can be used by a [VoxelTerrain] node.
static func create_voxel_material(atlas_image: Image) -> StandardMaterial3D:
	var voxel_material: StandardMaterial3D = StandardMaterial3D.new()
	
	voxel_material.albedo_texture = ImageTexture.create_from_image(atlas_image)
	voxel_material.vertex_color_use_as_albedo = true
	voxel_material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC
	
	return voxel_material


## Creates a [VoxelBlockyLibrary] using the provided [BlockLibrary].
static func create_voxel_library(block_library: BlockLibrary) -> VoxelBlockyLibrary:
	var voxel_library: VoxelBlockyLibrary = VoxelBlockyLibrary.new()
	var atlas_size = _get_atlas_size(block_library)
	
	voxel_library.add_model(VoxelBlockyModelEmpty.new())

	var variants = block_library.get_all_variants()
	
	for variant in variants:
		variant.base_mesh = _adjust_uv_coordinates(variant.base_mesh, atlas_size, Vector2(variant.atlas_positions[0], 0))
		
		for rotated_mesh in _generate_rotations(variant.base_mesh, variant.rotations):
			var voxel: VoxelBlockyModelMesh = VoxelBlockyModelMesh.new()
			voxel.mesh = rotated_mesh
			
			var voxel_id = voxel_library.add_model(voxel)
			variant.voxel_ids.append(voxel_id)
	
	voxel_library.bake()
	return voxel_library


# Adjusts UV coordinates for each surface of a mesh to match the location of the model's texture in the atlas.  
static func _adjust_uv_coordinates(inital_mesh: Mesh, atlas_size: Vector2, atlas_position: Vector2) -> Mesh:
	var adjusted_mesh = ArrayMesh.new()
	var surface = inital_mesh.get_surface_count() - 1
	
	while surface > -1:
		var vertex_array = inital_mesh.surface_get_arrays(surface)
		var uv_array_texture = vertex_array[Mesh.ARRAY_TEX_UV]
		var uv_array_atlas = PackedVector2Array()
		
		for uv_texture in uv_array_texture:
			var uv_atlas = (uv_texture + atlas_position) / atlas_size
			uv_array_atlas.append(uv_atlas)
		
		vertex_array[Mesh.ARRAY_TEX_UV] = uv_array_atlas
		adjusted_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, vertex_array)
		surface -= 1
	
	return adjusted_mesh


# Rotates each Mesh of a BlockVariant.
static func _generate_rotations(mesh: Mesh, rotations: Array[Quaternion]) -> Array[Mesh]: 
	var rotated_meshes: Array[Mesh] = []
	
	for rotation in rotations:
		var rotated_mesh = Math.rotate_mesh(mesh, rotation, SC.eq_v3(0.5))
		rotated_meshes.append(rotated_mesh)
	
	return rotated_meshes


# Calculates the atlas size based on the number of unique textures within a BlockLibrary.
static func _get_atlas_size(block_library: BlockLibrary) -> Vector2i:
	var textures: Array[Image] = block_library.get_all_textures()
	var atlas_size: Vector2i = Vector2i(textures.size(), 1)
	return atlas_size
