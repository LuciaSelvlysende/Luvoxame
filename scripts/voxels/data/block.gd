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
@export var base_block_id: StringName

@export_group("Visuals")
@export var mesh_id: StringName
@export var texture_ids: Array[StringName] = []
@export var texture_sides: Array[Sides] = [Sides.ALL]

@export_group("Rotations")
@export var rotation_preset: RotationPresets
@export var rotations: Array[int] = [0]

var base_block: Block
var mesh: Mesh
var textures: Array[Image] = []
var texture_rects: Array[Rect2i] = []
var voxel_types: Array[VoxelType] = []


func prepare() -> void:
	base_block = VoxelAssets.get_block(base_block_id)
	
	if base_block:
		var default_block: Block = Block.new()
		var default_resource: Resource = Resource.new()
		
		for property in get_property_list():
			if [PROPERTY_USAGE_CATEGORY, PROPERTY_USAGE_GROUP, PROPERTY_USAGE_SUBGROUP].has(property.usage): continue
			if property.name in default_resource: continue
			if get(property.name) != default_block.get(property.name): continue
			set(property.name, base_block.get(property.name))
	
	mesh = ResourceManager.access(mesh_id)
	textures.assign(ResourceManager.access_array(texture_ids))
	texture_rects.resize(textures.size())
	rotations = _get_rotations()
	voxel_types.resize(rotations.size())


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
