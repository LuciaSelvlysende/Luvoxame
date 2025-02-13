class_name Block
extends Resource


enum Sides {
	ALL,
	X,
	Y,
	Z,
	POS_X,
	NEG_X,
	POS_Y,
	NEG_Y,
	POS_Z,
	NEG_Z,
}

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
@export var texture_sides: Array[Sides] = [Sides.ALL]

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


func get_texture_rect(side: Sides) -> Rect2i:
	if texture_sides.has(side):
		return texture_rects[texture_sides.find(side)]
	
	match side:
		Sides.POS_X, Sides.NEG_X: if texture_sides.has(Sides.X):
			return texture_rects[texture_sides.find(Sides.X)]
		Sides.POS_Y, Sides.NEG_Y: if texture_sides.has(Sides.Y):
			return texture_rects[texture_sides.find(Sides.Y)]
		Sides.POS_Z, Sides.NEG_Z: if texture_sides.has(Sides.Z):
			return texture_rects[texture_sides.find(Sides.Z)]
	
	return texture_rects[texture_sides.find(Sides.ALL)]


func _get_rotations() -> Array[int]:
	match rotation_preset:
		RotationPresets.USE_PROVIDED: return rotations
		RotationPresets.HORIZONTAL: return [0, 16, 10, 22]
		RotationPresets.VERTICAL: return [0, 2]
		RotationPresets.BOTH: return [0, 16, 10, 22, 8, 20, 2, 18]
		RotationPresets.AXIAL: return [0, 16, 4]
		_: return [0]
