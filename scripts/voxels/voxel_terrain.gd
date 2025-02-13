extends VoxelTerrain


func prepare() -> void:
	mesher = VoxelMesherBlocky.new()
	mesher.library = VoxelAssets.voxel_library
	material_override = VoxelAssets.voxel_material
