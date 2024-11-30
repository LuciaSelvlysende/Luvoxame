extends VoxelTerrain


func _ready() -> void:
	mesher = Game.voxel_assets.voxel_mesher
	material_override = Game.voxel_assets.voxel_material
	
	Voxels.voxel_tool = get_voxel_tool()
