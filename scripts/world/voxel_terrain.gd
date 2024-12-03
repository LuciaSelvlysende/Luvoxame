class_name VoxelTerrainScript_Lvx
extends VoxelTerrain

## Script for the main [VoxelTerrain]. Pretty barebones at the moment.


func _ready() -> void:
	mesher = Game.voxel_assets.voxel_mesher
	material_override = Game.voxel_assets.voxel_material
	Voxels.voxel_tool = get_voxel_tool()
