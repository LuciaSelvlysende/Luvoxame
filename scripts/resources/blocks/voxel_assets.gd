class_name VoxelAssets
extends Resource

## All assets that a [VoxelLoader] can create, bundled into one [Resource].


var atlas_image: Image  ## The image that is used to make a texture atlas for [param voxel_material].
var voxel_material: StandardMaterial3D  ## The default [Material] used for voxels by a [VoxelTerrain] node.
var voxel_library: VoxelBlockyLibrary  ## The [VoxelBlockyLibrary] used by [param voxel_mesher].
var voxel_mesher: VoxelMesherBlocky  ## The [VoxelMesher] used by a [VoxelTerrain] node.
