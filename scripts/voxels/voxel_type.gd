class_name VoxelType
extends VoxelBlockyModelMesh


var block: Block


static func create(block: Block, rotation: Basis) -> VoxelType:
	var voxel_type: VoxelType = VoxelType.new()

	voxel_type.block = block
	#voxel_type.mesh = Math.rotate_mesh(block.mesh, rotation)

	return voxel_type
