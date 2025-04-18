class_name Block
extends Resource

## A resource that stores information that describes an block.
##
## [b]See also:[/b] [BlockManager], [BlockTool], [BlockAtlas], [BlockLibrary] [br][br]

# Dependencies (Required):                  Dependencies (Suggested):
# - BlockManager (Luvoxame)                 - BlockLibrary (Luvoxame)
# - ValueInheritor (Lucia's Utilities)      - BlockAtlas (Luvoxame)
#                                           - BlockTool (Luvoxame)

# To-do List: TBD


## Specifies a face (or faces) on [member mesh]. Used for applying [member textures]
## to different faces, but may be used in other cases in the future.
enum Faces {
	ALL, ## All faces.
	X, ## Faces with a normal vector equal to (1, 0, 0) or (-1, 0, 0).
	Y, ## Faces with a normal vector equal to (0, 1, 0) or (0, -1, 0).
	Z, ## Faces with a normal vector equal to (0, 0, 1) or (0, 0, -1).
	POS_X, ## Faces with a normal vector equal to (1, 0, 0).
	NEG_X, ## Faces with a normal vector equal to (-1, 0, 0).
	POS_Y, ## Faces with a normal vector equal to (0, 1, 0).
	NEG_Y, ## Faces with a normal vector equal to (0, -1, 0).
	POS_Z, ## Faces with a normal vector equal to (0, 0, 1).
	NEG_Z, ## Faces with a normal vector equal to (0, 0, -1).
}

## Premade sets of rotations created for the Block.
enum RotationPresets {
	USE_PROVIDED, ## No preset is used, so [member rotations] is used as is.
	HORIZONTAL, ## Four rotations around the y-axis.
	VERTICAL, ## Two rotations, one rotated 180 degrees around the x-axis or z-axis (I don't remember). 
	BOTH, ## Eight rotations made by combining [constant HORIZTONAL] and [constant VERTICAL].
	AXIAL, ## Three rotations, one pointing in each positive axis (such as a log).
}

## An ID used to access this Block using [method BlockManager.get_block].
@export var id: StringName

@export_group("Inheritance")
## The [member Block.id] that propery values will be copied from. Overrides [member base_block].
@export var base_block_id: StringName
## The [Block] that property values will be copied from. See [ValueInheritor] for more
## information. Any @export property changed from the default value will NOT be modified.
@export var base_block: Block
## The [ValueInheritor] used to copy values from [member base_block] and [member BlockManager.base_block].
@export var inheritor: ValueInheritor = ValueInheritor.new()

@export_group("Visuals")
## The mesh used for [member VoxelBlockyModelMesh.mesh]. If
## using a [BlockLibrary], this is handled automatically.
@export var mesh: Mesh
## The material used for [method VoxelBlockyModel.set_material_override].
## If using a [BlockLibrary], this is handled automatically.
@export var material: ShaderMaterial
## Determines whether [method BlockAtlas.apply] will set the "texture_albedo"
## shader parameter of [member material] to use the generated atlas. 
@export var use_texture_atlas: bool = true
## An array of textures used by [member material]. If a BlockAtlas
## is NOT used, only the first texture will be used.
@export var textures: Array[Texture2D] = []
## An array of [enum Faces] that determines which faces of the mesh will have which texture. Each element corresponds
## to the texture at the same index in [member textures]. Only works if use_texture_atlas is [code]true[/code].
@export var texture_sides: Array[Faces] = [Faces.ALL]

@export_group("Rotations")
## A premade set of rotations created for the Block. See [enum RotationPresets].
@export var rotation_preset: RotationPresets
## An array of rotations created for the Block. See [member VoxelBlockyModel.set_mesh_ortho_rotation_index].
@export var rotations: Array[int] = [0]

## An array of indicies in [VoxelBlockyLibrary.models] that represent
## the variations (such as rotations) of the Block.
var variants: Array[int] = []
## An array of [StringName] ID, where each ID corresponds to the variant at the same index in [member variants].
var variant_ids: Array[StringName] = []

# TODO - Move to BlockAtlas.
var texture_rects: Array[Rect2i] = []


func prepare() -> void:
	# Inherit property values from base_block and Items.base_block.
	inheritor.default_object = Block.new()
	inheritor.exclude_object = Resource.new()
	
	if base_block_id:
		base_block = Blocks.get_block(base_block_id)
	
	inheritor.inherit(self, base_block)
	inheritor.inherit(self, Blocks.base_block)
	
	# Apply texture to material. If using BlockAtlas, this will be handled by BlockAtlas.apply().
	if textures and not use_texture_atlas:
		material = material.duplicate()
		material.set_shader_parameter("texture_albedo", textures.front())
	
	_apply_rotations_preset()
	
	# TODO - Move to BlockAtlas.
	texture_rects.resize(textures.size())


## Returns the variant (see [member variants]) specified by [param variant_id], which can be an 
## int (which is interpreted as an index in the [member variants] array) or a [String]/[StringName],
## (which will be interpreted as an ID in the [member variant_ids] array).
func get_variant(variant_id) -> int:
	if variant_id is int:
		if variant_id < 0 or variant_id >= variants.size(): return -1
		return variants[variant_id]
	
	if variant_id is String or variant_id is StringName:
		if not variant_ids.has(variant_id): return -1
		var index: int = variant_ids.find(variant_id)
		if index < 0 and index > variants.size(): return -1
		return variants[index]
	
	return -1


# TODO - Move to BlockAtlas.
func get_texture_rect(side: Faces) -> Rect2i:
	if texture_sides.has(side):
		return texture_rects[texture_sides.find(side)]
	
	match side:
		Faces.POS_X, Faces.NEG_X: if texture_sides.has(Faces.X):
			return texture_rects[texture_sides.find(Faces.X)]
		Faces.POS_Y, Faces.NEG_Y: if texture_sides.has(Faces.Y):
			return texture_rects[texture_sides.find(Faces.Y)]
		Faces.POS_Z, Faces.NEG_Z: if texture_sides.has(Faces.Z):
			return texture_rects[texture_sides.find(Faces.Z)]
	
	return texture_rects[texture_sides.find(Faces.ALL)]


# Applies [member rotation_preset] to [member rotations].
func _apply_rotations_preset() -> void:
	match rotation_preset:
		RotationPresets.USE_PROVIDED: pass
		RotationPresets.HORIZONTAL: rotations = [0, 16, 10, 22]
		RotationPresets.VERTICAL: rotations = [0, 2]
		RotationPresets.BOTH: rotations = [0, 16, 10, 22, 8, 20, 2, 18]
		RotationPresets.AXIAL: rotations = [0, 16, 4]
