class_name VoxelsAutoload
extends Node3D


const AIR: int = 0

var block_library: BlockLibrary
var voxel_atlas: VoxelAtlas
var voxel_library: VoxelLibrary
var voxel_material: StandardMaterial3D
var voxel_terrain: VoxelTerrain
var voxel_tool: VoxelTool


func _ready() -> void:
	block_library = load("uid://qng2hx01nyki")
	voxel_atlas = VoxelAtlas.create_atlas(block_library)
	voxel_library = VoxelLibrary.create(block_library)
	voxel_material = load("uid://bl8pu4arv3vjc")
	voxel_material.albedo_texture = ImageTexture.create_from_image(voxel_atlas)
	voxel_terrain = find_child("VoxelTerrain", false)
	voxel_tool = voxel_terrain.get_voxel_tool()


## Returns a [Dictionary] of adjacent voxel positions.
func get_adjacent_voxels(voxel: Vector3i) -> Dictionary:
	return {
		"up"    = voxel + Vector3i(0, 1, 0),
		"down"  = voxel + Vector3i(0, -1, 0),
		"north" = voxel + Vector3i(0, 0, -1),
		"south" = voxel + Vector3i(0, 0, 1),
		"east"  = voxel + Vector3i(-1, 0, 0),
		"west"  = voxel + Vector3i(1, 0, 0),
		}


## Shortcut function that checks if an position is air.
func is_air(position: Vector3i) -> bool:
	return voxel_tool.get_voxel(position) == 0


## Checks if the voxel is supported on any side. Can optionally specify particular [param directions] to check for support.
func is_supported(voxel_position: Vector3i, directions: Array[StringName] = ["up", "down", "north", "east", "south", "west"]) -> bool:
	var adjacent_voxels = get_adjacent_voxels(voxel_position)

	for voxel in adjacent_voxels.keys():
		if is_air(voxel) and directions.has(voxel): return true

	return false
