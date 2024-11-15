class_name BlockVariant
extends Resource

## A variant of a [Block].


## Various presets for rotations.
enum ROTATION_PRESETS {
	NO_ROTATION,  ## Only the base mesh is used.
	USE_PROVIDED,  ## Uses the provided rotations to generated rotated meshes.
	HORIZONTAL_DIRECTIONS,  ## Creates four rotated meshes, one for each 90 degree rotation around the y-axis.
	VERTICAL_DIRECTIONS,  ## Creates two rotated meshes, one from the base mesh, and one rotated 180 degrees around the x-axis.
	ALL_DIRECTIONS,  ## Creates eight rotated meshes by combining [param HORIZTONAL_DIRECTIONS] and [param VERTICAL_DIRECTIONS].
#	THREE_AXIS, (Unimplimented)
}


@export var id: StringName  ## The id used to find the [BlockVariant] in a [BlockLibrary].

@export_group("Textures")
@export var textures: Array[Image]  ## The textures used by the [BlockVariant]. All textures of all [BlockVariants] in a [BlockLibrary] must have the same dimensions.

@export_group("Shape")
@export var base_mesh: Mesh  ## The [Mesh] used by the [BlockVariant].
@export var collision_use_mesh: bool = true  ## If [code]true[/code], the [BlockVariant]'s collision shape will be generated from it's [param base_mesh].
@export var collision_mesh: Mesh  ## The [Mesh] that is used to create the [BlockVariant]'s collision shape.

@export_group("Rotations")
@export var rotations: Array[Quaternion]  ## The rotations used to generate voxels for the [BlockVariant].
@export var rotation_preset: ROTATION_PRESETS  ## Preset that covers common rotations.

@export_group("Properties")
@export var attributes: Array[BlockLibrary.ATTRIBUTES] = []  ## Simple properties that the [BlockVariant] either has, or doesn't have.

var atlas_positions: Array[int] = []  ## The position of each texture of a [BlockVariant] on the most recently created texture atlas.
var collision_shapes: Array[ConcavePolygonShape3D]  ## The collision shapes used by the [BlockVariant]. Corresponds with [param voxel_ids].
var meshes: Array[Mesh]  ## The meshes used by the [BlockVariant]. Corresponds with [param voxel_ids].
var voxel_ids: Array[int]  ## The voxel indicies in the most recently made [VoxelBlockyLibrary] that contains this [BlockVariant]. May have multiple, depending on [param rotations].


## Returns the [Mesh] of the provided voxel with the correct rotation.
func get_rotated_mesh_from_voxel(voxel_id: int) -> Mesh:
	var index: int = voxel_ids.find(voxel_id)
	var rotation: Quaternion = rotations[index]
	return Math.rotate_mesh(base_mesh, rotation, Shcut.eq_v3(0.5))


## Returns the [ConcavePolygonShape3D] of the provided voxel.
func get_collision_shape_from_voxel(voxel_id: int) -> ConcavePolygonShape3D:
	var index: int = voxel_ids.find(voxel_id)
	return collision_shapes[index]


# Sets rotations based on rotation_preset.
func _update_rotations():
	match rotation_preset:
		ROTATION_PRESETS.NO_ROTATION:
			rotations = [Quaternion(0, 0, 0, 0)]
		
		ROTATION_PRESETS.USE_PROVIDED:
			pass
		
		ROTATION_PRESETS.HORIZONTAL_DIRECTIONS:
			rotations = [
				Quaternion(0, 0, 0, 0),
				Quaternion(0, 1, 0, 90),
				Quaternion(0, 1, 0, 180),
				Quaternion(0, 1, 0, 270),
			]
		
		ROTATION_PRESETS.VERTICAL_DIRECTIONS:
			rotations = [
				Quaternion(0, 0, 0, 0),
				Quaternion(1, 0, 0, 180),
			]
		
		ROTATION_PRESETS.ALL_DIRECTIONS:
			rotations = [
				Quaternion(0, 0, 0, 0),
				Quaternion(0, 1, 0, 90),
				Quaternion(0, 1, 0, 180),
				Quaternion(0, 1, 0, 270),
				Quaternion(1, 0, 0, 180),
				Quaternion(1, 0, -1, 180),
				Quaternion(0, 0, -1, 180),
				Quaternion(-1, 0, -1, 180),
			]
		
#		ROTATION_PRESETS.THREE_AXIS: (Unimplimented)
#			rotations = [
#				Quaternion(0, 0, 0, 0),
#				Quaternion(1, 0, 0, 90),
#				Quaternion(0, 0, 1, 90),
#			]
	
	return rotations


# Generates a ConvexPolygonShape3D from either a variants's model/collision mesh.
func _generate_collision_shapes() -> void:
	for rotation in rotations:
		var mesh: Mesh
		if collision_use_mesh == true:
			mesh = Math.rotate_mesh(base_mesh, rotation, Shcut.eq_v3(0.5))
		else:
			mesh = Math.rotate_mesh(collision_mesh, rotation, Shcut.eq_v3(0.5))
		
		collision_shapes.append(mesh.create_trimesh_shape())
