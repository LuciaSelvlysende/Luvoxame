class_name BlockManager
extends Node

## An autoload that stores and manages all [Block] resources in the game.
##
## [b]See also:[/b] [Block], [BlockTool] [br][br]
##
## This node is designed to be used as an autoload. However, since autoloads do not support
## [code]@export[/code], certain values need to be configured within the [InventoryManager] script.
## These are marked by the [code]@export[/code] annotation to make it clear what is intended to be
## modified, despite the functionality not being available.

# Dependencies (Required):
# - Block (Luvoxame)
# - BlockAtlas (Luvoxame)
# - BlockLibrary (Luvoxame)
# - ResourceGroup (Godot Resource Groups)

# To-do List: TBD


## Stores all blocks in the game. The uid parameter should point to a [ResourceGroup].
@export var blocks: Dictionary[StringName, Block] = load_blocks("uid://di0y8d8wu3yft")
## The [Block] that all blocks will copy property values from. See [ValueInheritor] for more information.
## Any @export property on the that is changed from the default value will NOT be modified.
@export var base_block: Block = load("uid://b6iltq3x4m1ul")

## The [BlockAtlas] that stores textures from all [Block]s that have
## [member Block.use_texture_atlas] set to [code]true[/code].
var atlas: BlockAtlas
## The [BlockLibrary] (which inherits from [VoxelBlockyLibrary]) that can be used by [VoxelTerrain]s.
var library: BlockLibrary


func _ready() -> void:
	# Assign default values.
	for block in blocks.values():
		block.prepare()
	
	# Create resources needed for Zylann's Voxel Tools.
	atlas = BlockAtlas.new(blocks.values())
	atlas.apply_array(blocks.values())
	library = BlockLibrary.build(blocks.values())


## Loads [Block]s specified by the [ResourceGroup] that [param item_group_uid] points to.
func load_blocks(block_group_uid: String) -> Dictionary[StringName, Block]:
	var loaded_blocks: Dictionary[StringName, Block] = {}
	
	var resource_group: ResourceGroup = load(block_group_uid)
	if not resource_group: return {}
	
	for resource in resource_group.load_all():
		if not resource is Block: continue
		loaded_blocks[resource.id] = resource
	
	return loaded_blocks


## Adds a [param block] to [member blocks]. Returns [constant ERR_ALREADY_EXISTS]
## if [member Block.id] is already present.
func add_block(block: Block) -> Error:
	if blocks.has(block.id): return ERR_ALREADY_EXISTS
	blocks[block.id] = block
	return OK


## Returns the [Block] in [member blocks] specified by [param block_id].
## Returns [code]null[/code] if not present.
func get_block(block_id: StringName) -> Block:
	return blocks.get(block_id)


## Returns the [Block] in [member blocks] that has [param voxel_id] as one of it's
## [Block.variants]. Returns [code]null[/code] if no matching block is found.
func get_block_from_voxel(voxel_id) -> Block:
	for block in blocks.values():
		if block.variants.has(voxel_id): return block
	
	return null


## Takes a [Variant] parameter and returns either [code]null[/code] or [Block].
## Blocks are returned unchanged. [String]s and [StringName]s are tried as IDs. 
func ensure_block(param) -> Block:
	if not param: return null
	if param is Block: return param
	if not [TYPE_STRING, TYPE_STRING_NAME].has(typeof(param)): return null
	return get_block(param)
