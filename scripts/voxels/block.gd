class_name Block
extends Resource


enum RotationPresets {
	USE_PROVIDED,
	HORIZONTAL,
	VERTICAL,
	BOTH,
	AXIAL,
}

@export var id: StringName
@export var base_block: Block
@export var attributes: Array[StringName]
#@export var properties: Array[BlockProperty]

@export_group("Visuals")
@export var mesh: Mesh
@export var textures: Array[Image] = []

@export_group("Rotations")
@export var rotation_preset: RotationPresets
@export var rotations: Array[OrthagonalBasis] = []

var voxel_types: Array[VoxelType] = []
