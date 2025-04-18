class_name BlockTool
extends  RefCounted

## A wrapper for [VoxelTool] that uses [Block]s instead of voxel indicies.
##
## [b]See also:[/b] [Block] [br][br]
##
## Before [BlockTool] can be used, you must set [member terrain]
## to the [VoxelTerrain] the BlockTool will be acting on.


## The index of air (a [VoxelBlockyModelEmpty]) in [member VoxelBlockyLibrary.models].
const AIR_VOXEL_INDEX: int = 0

## Custom error constants.
enum BlockError {
	OK,
	ERR_INVALID_BLOCK,
	ERR_INVALID_VARIANT,
	ERR_AREA_NOT_EDITABLE,
}

## The [VoxelTerrain] that the BlockTool is currently acting on.
static var terrain: VoxelTerrain:
	set(value):
		terrain = value
		_voxel_tool = terrain.get_voxel_tool() if terrain else null

# The VoxelTool that the BlockTool is currently using.
static var _voxel_tool: VoxelTool


## Sets [param position] to the voxel specified by [block] and
## [param variant_id]. Wrapper for [method VoxelTool.set_voxel].
static func set_block(block: Variant, variant_id: Variant, position: Vector3i) -> BlockError:
	block = Blocks.ensure_block(block)
	if not block: return BlockError.ERR_INVALID_BLOCK
	var variant: int = block.get_variant(variant_id)
	if not block.get_variant(variant_id): return BlockError.ERR_INVALID_VARIANT
	
	if not _voxel_tool.is_area_editable(AABB(position, Vector3.ONE)): return BlockError.ERR_AREA_NOT_EDITABLE
	
	_voxel_tool.set_voxel(position, variant)
	return BlockError.OK


## Sets [param position] to air. 
static func set_air(position: Vector3i) -> BlockError:
	if not _voxel_tool.is_area_editable(AABB(position, Vector3.ONE)): return BlockError.ERR_AREA_NOT_EDITABLE
	
	_voxel_tool.set_voxel(position, AIR_VOXEL_INDEX)
	return BlockError.OK


## Returns the [Block] that has a variant at [param position].
static func get_block(position: Vector3i) -> Block:
	return Blocks.get_block_from_voxel(_voxel_tool.get_voxel(position))


## Returns a dictionary of adjacent voxel positions. Keys are cardinal directions
## as strings ("up", "down", "north", "south", "east", and "west").
static func get_adjacent_voxels(voxel: Vector3i) -> Dictionary[String, Vector3i]:
	return {
		"up"    = voxel + Vector3i(0, 1, 0),
		"down"  = voxel + Vector3i(0, -1, 0),
		"north" = voxel + Vector3i(0, 0, -1),
		"south" = voxel + Vector3i(0, 0, 1),
		"east"  = voxel + Vector3i(-1, 0, 0),
		"west"  = voxel + Vector3i(1, 0, 0),
		}


## Returns [code]true[/code] if the voxel at [param position] is air. 
static func is_air(position: Vector3i) -> bool:
	return _voxel_tool.get_voxel(position) == 0


## Returns [code]true[/code] if [param position] has a neighboring non-air block. Can specify which
## neighbors are checked via [param directions]. See [method get_adjacent_voxels for more information.
static func is_supported(position: Vector3i, directions: Array[StringName] = ["up", "down", "north", "east", "south", "west"]) -> bool:
	var adjacent_voxels = get_adjacent_voxels(position)

	for voxel in adjacent_voxels.keys():
		if not is_air(adjacent_voxels[voxel]) and directions.has(voxel): return true
	
	return false
