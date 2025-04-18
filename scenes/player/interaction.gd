extends Node3D


@export var reach: float = 5.0

var raycast: VoxelRaycast = VoxelRaycast.new()

@onready var player: CharacterBody3D = $".."
@onready var camera: Camera3D = %Camera
@onready var inventory: Node = %Inventory

@onready var manual_timer: Timer = %ManualTimer
@onready var auto_continuous_timer: Timer = %AutoContinuousTimer
@onready var auto_initial_timer: Timer = %AutoInitialTimer
@onready var indicator_timer: Timer = %IndicatorTimer
@onready var indicator_area: Area3D = %IndicatorArea
@onready var indicator_mesh: MeshInstance3D = %IndicatorMesh


func _unhandled_input(event: InputEvent) -> void:
	if not manual_timer.is_stopped(): return
	
	if event.is_action_pressed("place") or event.is_action_pressed("break"):
		manual_timer.start()
		auto_initial_timer.start()
	
	if event.is_action_pressed("place"):
		place_block(inventory.get_selected_block())
	
	if event.is_action_pressed("break"):
		remove_block()


func _on_cooldown_timeout() -> void:
	if Input.is_action_pressed("place"):
		auto_continuous_timer.start()
		place_block(inventory.get_selected_block())
	elif Input.is_action_pressed("break"):
		auto_continuous_timer.start()
		remove_block()
	else:
		auto_continuous_timer.stop()


func _on_refresh_indicator() -> void:
	update_indicator()


func update_raycast() -> void:
	raycast.raycast(camera.global_position, -camera.global_basis.z.normalized(), reach)


func place_block(block: Block, variant: Variant = 0):
	if indicator_area.get_overlapping_bodies().has(player): return
	update_indicator()
	
	var place_position: Vector3i = raycast.get_target_empty()
	if place_position == Vector3i(INF, INF, INF):
		place_position = raycast.get_supported_empty()
	if place_position == Vector3i(INF, INF, INF): return
	
	inventory.remove_block(block)
	BlockTool.set_block(block, variant, place_position)


func remove_block():
	update_indicator()
	
	var break_position: Vector3i = raycast.get_target_solid()
	if break_position == Vector3i(INF, INF, INF): return
	
	inventory.add_block(BlockTool.get_block(break_position))
	BlockTool.set_air(break_position)


func update_indicator():
	update_raycast()
	
	var is_holding_block: bool = not not inventory.get_selected_block()
	var target_empty: Vector3i = raycast.get_target_empty()
	
	var indicator_position: Vector3i = (
		target_empty if is_holding_block and target_empty != Vector3i(INF, INF, INF)
		else raycast.get_supported_empty() if is_holding_block
		else raycast.get_target_solid()
	)
	
	var show_indicator: bool = indicator_position != Vector3i(INF, INF, INF)
	global_position = indicator_position if show_indicator else Vector3i()
	visible = show_indicator
