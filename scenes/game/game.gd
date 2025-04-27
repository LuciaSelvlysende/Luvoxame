extends Node3D


@export_group("Autoload Exports")
@export var resources: Dictionary[StringName, Resource] = {}
@export var blocks: Array[Block] = []
@export var voxel_terrain: VoxelTerrain
@export var items: Array[Item] = []
@export var default_item: Item
@export var inventories: Array[Inventory] = []
