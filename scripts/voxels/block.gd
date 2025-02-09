class_name Block
extends Resource


@export var id: StringName
@export var base_block: Block
@export var attributes: Array[StringName]
#@export var properties: Array[BlockProperty]

@export_group("Visuals")
@export var mesh: Mesh
@export var textures: Array[Image] = []

@export_group("Rotations")
@export var rotation_preset: VoxelRotations.Presets
@export var rotations: Array[OrthoBasis] = []

var texture_rects: Array[Rect2i] = []
var voxel_types: Array[VoxelType] = []


func prepare() -> void:
	texture_rects.resize(textures.size())
	rotations = VoxelRotations.get_rotations(rotation_preset)
	voxel_types.resize(rotations.size())


func get_rotations() -> Array[Basis]:
	return rotations.map(func (ortho_basis): ortho_basis.get_basis())
