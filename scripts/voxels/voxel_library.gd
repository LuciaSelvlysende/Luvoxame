class_name VoxelLibrary
extends VoxelBlockyLibrary


var blocks: Array[Block]


## Creates a [VoxelLibrary] using [Block]s from [block_library].
static func create(block_library: BlockLibrary) -> VoxelLibrary:
	var voxel_library: VoxelBlockyLibrary = VoxelBlockyLibrary.new()

	# Add air.
	voxel_library.add_model(VoxelBlockyModelEmpty.new())

	# Add blocks.
	for block in block_library.blocks:
		block.mesh = _adjust_uv_coordinates(block.mesh, Voxels.voxel_atlas.texture_rects[block.id][0])

		for rotation in block.get_rotations():
			voxel_library.add_model(VoxelType.create(block, rotation))

	voxel_library.bake()
	return voxel_library


# Helper function for create(). Adjusts UV coordinates for each surface of a mesh to match the location of the model's texture in the atlas.
static func _adjust_uv_coordinates(mesh: Mesh, texture_rect: Rect2i) -> Mesh:
	var adjusted_mesh = ArrayMesh.new()
	var surface = mesh.get_surface_count() - 1

	while surface > -1:
		var vertex_array = mesh.surface_get_arrays(surface)
		var uv_array_texture = vertex_array[Mesh.ARRAY_TEX_UV]
		var uv_array_atlas = PackedVector2Array()

		for uv_texture in uv_array_texture:
			var uv_atlas = (uv_texture + atlas_position) / atlas_size
			uv_array_atlas.append(uv_atlas)

			vertex_array[Mesh.ARRAY_TEX_UV] = uv_array_atlas
			adjusted_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, vertex_array)
			surface -= 1

		return adjusted_mesh
