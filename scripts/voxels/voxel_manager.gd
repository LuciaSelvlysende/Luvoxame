class_name Voxels
extends Node


@export var voxel_terrain: VoxelTerrain

var voxel_id: int = 1
var voxel_tool: VoxelTool


func _ready() -> void:
	VoxelAssets.prepare()
	voxel_terrain.prepare()
	voxel_tool = voxel_terrain.get_voxel_tool()
	VoxelTools._voxel_tool = voxel_tool


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		voxel_id += 1
	
	if event.is_action_pressed("ui_down"):
		voxel_id -= 1
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if not voxel_tool.is_area_editable(AABB(Vector3(-3 , 2, -3), Vector3.ONE)): return
	voxel_tool.set_voxel(Vector3(-3 , 2, -3), voxel_id)
