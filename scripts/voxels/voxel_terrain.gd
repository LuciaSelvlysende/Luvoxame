extends VoxelTerrain


func _ready() -> void:
	await Voxels.ready
	mesher = VoxelMesherBlocky.new()
	mesher.library = Voxels.voxel_library
	material_override = Voxels.voxel_material
