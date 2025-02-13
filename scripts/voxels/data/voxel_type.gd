class_name VoxelType
extends VoxelBlockyModelMesh


var block: Block


static func create(block: Block, rotation: int) -> VoxelType:
	var voxel_type: VoxelType = VoxelType.new()
	
	voxel_type.block = block
	voxel_type.mesh = block.mesh
	voxel_type.mesh_ortho_rotation_index = rotation
	
	return voxel_type
