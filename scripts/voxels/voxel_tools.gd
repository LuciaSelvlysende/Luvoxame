class_name VoxelTools
extends  RefCounted


static var _voxel_tool: VoxelTool


## Returns a [Dictionary] of adjacent voxel positions.
static func get_adjacent_voxels(voxel: Vector3i) -> Dictionary:
	return {
		"up"    = voxel + Vector3i(0, 1, 0),
		"down"  = voxel + Vector3i(0, -1, 0),
		"north" = voxel + Vector3i(0, 0, -1),
		"south" = voxel + Vector3i(0, 0, 1),
		"east"  = voxel + Vector3i(-1, 0, 0),
		"west"  = voxel + Vector3i(1, 0, 0),
		}


## Shortcut function that checks if a voxel is air.
static func is_air(voxel: Vector3i) -> bool:
	return _voxel_tool.get_voxel(voxel) == 0


## Checks if the voxel is supported on any side. Can optionally specify particular [param directions] to check for support.
static func is_supported(voxel_position: Vector3i, directions: Array[StringName] = ["up", "down", "north", "east", "south", "west"]) -> bool:
	var adjacent_voxels = get_adjacent_voxels(voxel_position)

	for voxel in adjacent_voxels.keys():
		if is_air(voxel) and directions.has(voxel): return true

	return false


static func set_voxel(position: Vector3i, voxel_id: int) -> void:
	_voxel_tool.set_voxel(position, voxel_id)
