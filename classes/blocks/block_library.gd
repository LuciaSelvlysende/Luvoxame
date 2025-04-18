class_name BlockLibrary
extends VoxelBlockyLibrary

## A [VoxelBlockLibrary] created from [Block]s.
##
## [b]See also:[/b] [Block], [BlockManager] [br][br]
##
## A BlockLibrary is automatically created by [BlockManager] and stored
## in [BlockManager.library]. Can be used by Zylann's Voxel Tools.

# Dependencies (Required):      Dependencies (Suggested):
# - Block (Luvoxame)            - BlockManager (Luvoxame)
# - BlockVariant (Luvoxame)

# To-do List: TBD


## Creates a [BlockLibrary] containing [BlockVariant]s representing all [Block.variants] of all [param blocks].
static func build(blocks: Array[Block]) -> BlockLibrary:
	var library: BlockLibrary = BlockLibrary.new()
	library.add_model(VoxelBlockyModelEmpty.new())
	
	for block in blocks: for rotation in block.rotations:
		var voxel_type: BlockVariant = BlockVariant.create(block, rotation)
		block.variants.append(library.models.size())
		library.add_model(voxel_type)
	
	# If needed, add a plain cube model so that terrain can generate.
	if library.models.size() == 1:
		library.add_model(VoxelBlockyModelCube.new())
	
	library.bake()
	return library
