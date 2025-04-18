extends VoxelTerrain


func _ready() -> void:
	mesher.library = Blocks.library
	BlockTool.terrain = self
