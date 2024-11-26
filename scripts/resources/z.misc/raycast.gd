class_name Raycast
extends RaycastBasePrecise


@export var targeted_voxel_position: Vector3  ## The position of the first voxel the ray passed through.
@export var targeted_voxel_id: int  ## The id of the first voxel the ray passed through.
@export var targeted_block_id: StringName  ## The id of the first [Block] the ray passed through.
@export var targeted_variant_id: StringName  ## The id of the first [BlockVariant] the ray passed through.

@export var targeted_space_position: Vector3  ## The position of the last empty voxel space (air) the ray passed through.
@export var targeted_space_supported: bool  ## Whether or not the targeted space is adjacent to a non-air voxel.


func raycast(origin: Vector3, direction: Vector3, length: float):
	super(origin, direction, length)
	interpret()


func _precise_condition() -> bool:
	if Game.block_library.voxel_has_attribute(Voxels.voxel_tool.get_voxel(results[-1]), BlockLibrary.ATTRIBUTES.PARTIAL): return true
	return false


func _stop_condition() -> bool:
	if results[-1] == results[-2]: return true
	if Game.block_library.voxel_has_attribute(Voxels.voxel_tool.get_voxel(results[-1]), BlockLibrary.ATTRIBUTES.PARTIAL): return false
	if Voxels.voxel_tool.get_voxel(results[-1]) != Voxels.AIR: return true
	return false


func interpret() -> void:
	var voxel_id: int = Voxels.voxel_tool.get_voxel(results.back())
	
	if voxel_id == Voxels.AIR:
		targeted_voxel_position = results.back()
		targeted_space_position = results.back()
	else:
		targeted_voxel_position = results.back()
		targeted_space_position = results[results.size() - 2]
	
	if Game.block_library.voxel_has_attribute(voxel_id, BlockLibrary.ATTRIBUTES.PARTIAL):
		targeted_space_position = results.back() + Vector3i(collision_normal)
	
	targeted_voxel_id = Voxels.voxel_tool.get_voxel(targeted_voxel_position)
	targeted_block_id = Game.block_library.get_block_from_voxel(targeted_voxel_id).id
	targeted_variant_id = Game.block_library.get_variant_from_voxel(targeted_voxel_id).id
	targeted_space_supported = true if Voxels.is_supported(targeted_space_position) else false
