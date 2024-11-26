class_name Game
extends Node3D


@export var worlds: Array[PackedScene]
@export var default_block_library: BlockLibrary

static var block_library: BlockLibrary  ## The block library used by the game.
static var physics_space: PhysicsDirectSpaceState3D  ## Provides access to the world's physics space.
static var voxel_assets: VoxelAssets

var current_root: Node
var current_world: int = 0


func _ready() -> void:
	block_library = default_block_library
	block_library.prepare()
	
	voxel_assets = VoxelLoader.create_all_voxel_assets(block_library)
	
	physics_space = get_world_3d().direct_space_state
	load_world(worlds[0])


func _on_reset_world() -> void:
	unload_world()
	load_world(worlds[0])


func load_world(scene: PackedScene) -> void:
	current_root = scene.instantiate()
	add_child(current_root)


func unload_world() -> void:
	current_root.queue_free()
