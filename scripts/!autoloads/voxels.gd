class_name VoxelsAutoload
extends Node

## Manages voxels. Voxels are universal per session (unless changing versions or applying mods, once support is added), so need to be preserved throughout scene changes.


const AIR: int = 0  ## Index of air in a voxel library.

var block_library: BlockLibrary = BlockLibrary.new() ## Stores information about all [Block]s in the game.
var voxel_assets: VoxelLoader.VoxelAssets  ## Stores assets that can be used by a [VoxelTerrain] node.
var voxel_tool: VoxelTool  ## Provides access to a [VoxelTool].


## Shortcut function that checks if an position is air.
func is_air(position: Vector3i) -> bool:
	return voxel_tool.get_voxel(position) == AIR


## Returns a [Dictionary] of adjacent voxel positions.
func get_adjacent_voxels(voxel_position: Vector3i) -> Dictionary:
	var results = {
		up    = voxel_position + Vector3i(0, 1, 0),
		down  = voxel_position + Vector3i(0, -1, 0),
		north = voxel_position + Vector3i(0, 0, -1),
		south = voxel_position + Vector3i(0, 0, 1),
		east  = voxel_position + Vector3i(-1, 0, 0),
		west  = voxel_position + Vector3i(1, 0, 0),
	}
	
	return results


## Checks if the voxel is supported on any side. Can optionally specify particular [param directions] to check for support. 
func is_supported(voxel_position: Vector3i, directions: Array[StringName] = ["up", "down", "north", "east", "south", "west"]) -> bool:
	var adjacent_voxels = get_adjacent_voxels(voxel_position)
	for voxel in adjacent_voxels.keys():
		if Voxels.voxel_tool.get_voxel(adjacent_voxels[voxel]) != Voxels.AIR and directions.has(voxel):
			return true
	
	return false
