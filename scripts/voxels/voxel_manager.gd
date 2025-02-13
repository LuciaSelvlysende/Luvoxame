class_name VoxelManager
extends Node


@export var voxel_terrain: VoxelTerrain

var test: int = 0


func _ready() -> void:
	VoxelAssets.prepare()
	voxel_terrain.prepare()


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_accept"): return
	voxel_terrain.get_voxel_tool().set_voxel(Vector3(-3 , 2, -3), test)
	test += 1
