class_name BlockVariant
extends VoxelBlockyModelMesh

## A [VoxelBlockyModelMesh] that stores extra information related to the [Block] system.
##
## [b]See also:[/b] [Block] [br][br]

# Dependencies (Required):          Dependencies (Suggested):
# - Block                           - BlockLibrary
#                                   - BlockManager

# To-do List: TBD


## The [Block] that the BlockVariant is a variant of.
var block: Block


## Creates a functional BlockVariant that's ready to be used in [VoxelBlockyLibrary] or [BlockLibrary].
static func create(init_block: Block, rotation: int) -> BlockVariant:
	var voxel_type: BlockVariant = BlockVariant.new()
	
	voxel_type.block = init_block
	voxel_type.mesh = init_block.mesh
	voxel_type.collision_aabbs = [init_block.mesh.get_aabb()]
	voxel_type.mesh_ortho_rotation_index = rotation
	voxel_type.set_material_override(0, init_block.material)
	
	return voxel_type
