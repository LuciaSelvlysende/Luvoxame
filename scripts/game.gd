class_name Game
extends Node3D

## Root node of the game. Will be expanded upon later.


@export var world_scene: PackedScene  ## The scene that is used to load the [member world]. Will be expanded upon later.
@export var default_block_library: BlockLibrary  ## The default block library that is loaded initially. Support will eventually be added for custom block libraries.

static var block_library: BlockLibrary  ## The block library used by the game.
static var physics_space: PhysicsDirectSpaceState3D  ## Provides access to the world's physics space.
static var voxel_assets: VoxelAssets  ## The assets used by [VoxelTerrain]s and a few other nodes.
static var world: Node3D ## The root node of the current world scene.


func _ready() -> void:
	block_library = default_block_library
	block_library.prepare()
	
	voxel_assets = VoxelLoader.create_all_voxel_assets(block_library)
	physics_space = get_world_3d().direct_space_state
	world = world_scene.instantiate()
	
	add_child(world)
