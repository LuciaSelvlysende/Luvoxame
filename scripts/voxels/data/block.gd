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

@export_group("Visuals")
@export var mesh: Mesh
@export var textures: Array[Image] = []

@export_group("Rotations")
@export var rotation_preset: RotationPresets
@export var rotations: Array[int] = [0]

var texture_rects: Array[Rect2i] = []
var voxel_types: Array[VoxelType] = []


func prepare() -> void:
	texture_rects.resize(textures.size())
	rotations = _get_rotations()
	voxel_types.resize(rotations.size())
	
	if not base_block: return
	var default_block: Block = Block.new()
	
	for property in base_block.get_property_list():
		if get(property.name) != default_block.get(property.name): continue
		set(property.name, base_block.get(property.name))


func _get_rotations() -> Array[int]:
	match rotation_preset:
		RotationPresets.USE_PROVIDED: return rotations
		RotationPresets.HORIZONTAL: return [0, 16, 10, 22]
		RotationPresets.VERTICAL: return [0, 2]
		RotationPresets.BOTH: return [0, 16, 10, 22, 8, 20, 2, 18]
		RotationPresets.AXIAL: return [0, 16, 4]
		_: return [0]
