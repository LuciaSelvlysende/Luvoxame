extends VoxelTerrain

@export var block_library: BlockLibrary  ## Autoloads don't show in the inspector, so this is used by the Voxels autoload.


func _ready() -> void:
	mesher = Game.voxel_assets.voxel_mesher
	material_override = Game.voxel_assets.voxel_material
	
	Voxels.voxel_tool = get_voxel_tool()
	
