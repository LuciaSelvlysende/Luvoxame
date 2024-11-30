extends Node3D


# Controls what type of interaction is used.
enum INTERACTION_MODES {
	BREAK,
	PLACE,
}

@export_range(0, 25, 1, "or_greater") var interaction_range: float  ## The maximum range the player can interact with things.
@export_range(0, 1, 0.05, "or_greater") var initial_delay: float  ## The delay between placing the first voxel and the second.
@export_range(0, 1, 0.05, "or_greater") var continuous_delay: float  ## The delay between placing the second voxel and the third, and all subsequent voxels.
@export_range(0, 0.375, 0.0625) var diagonal_placement_threshold: float  ## 

@export_group("Materials")
@export var break_preview_material: StandardMaterial3D  ## Sets the base material used for the block outline. [param albedo_texture] will be overridden upon loading the game.
@export var place_preview_material: StandardMaterial3D  ## Sets the base material used for the placement preview. [param albedo_texture] will be overridden upon loading the game.

@export_group("Node Connections")
@export var camera: Camera3D  ## Used to get the direction for raycasting.
@export var cooldown: Timer  ## Used to control how fast voxels can be placed.
@export var preview: MeshInstance3D  ## Used to display a preview for what will be placed/broken.

var is_initial_placement: bool = true  # Controls which cooldown duration (initial_delay/continuous_delay) is used.
var midair_placement_enabled: bool = false  # When true, allows placing voxels midair.
var preview_mode: INTERACTION_MODES  # Controls which preview type (breaking/placing) is shown.
var raycast: Raycast = Raycast.new().precise_setup(Game.physics_space)  # Raycast used for interaction. 


func _ready():
	place_preview_material.albedo_texture = Game.voxel_assets.voxel_material.albedo_texture


func _on_player_tick() -> void:
	raycast.raycast(global_position, camera.get_direction_vector(), interaction_range)
	
	match preview_mode:
		INTERACTION_MODES.BREAK:
			preview_break(raycast)
		INTERACTION_MODES.PLACE:
			preview_place(raycast)


func _unhandled_input(event):
	if event.is_action_pressed("setting2"):
		preview_mode = SC.toggle(preview_mode, INTERACTION_MODES.BREAK, INTERACTION_MODES.PLACE)

	if event.is_action_pressed("setting3"):
		midair_placement_enabled = not midair_placement_enabled
	
	if Input.is_action_just_released("break") or Input.is_action_just_released("place"):
		is_initial_placement = true


func _process(_delta):
	if Input.is_action_pressed("break"):
		interact(INTERACTION_MODES.BREAK)
	
	if Input.is_action_pressed("place"):
		interact(INTERACTION_MODES.PLACE)


# Interacts (breaks/places) based on the provided interaction mode.
func interact(interaction_mode: INTERACTION_MODES):
	if not is_initial_placement and not cooldown.is_stopped(): return
	raycast.raycast(global_position, camera.get_direction_vector(), interaction_range)
	
	match interaction_mode:
		INTERACTION_MODES.BREAK: break_voxel(raycast)
		INTERACTION_MODES.PLACE: place_voxel(raycast)
	
	cooldown.start(initial_delay if is_initial_placement else continuous_delay)
	is_initial_placement = false


# Breaks a voxel if possible.
func break_voxel(raycast: Raycast) -> void:
	if raycast.targeted_voxel_id == Voxels.AIR: return
	
	Voxels.voxel_tool.set_voxel(raycast.targeted_voxel_position, Voxels.AIR)


# Places a voxel if possible.
func place_voxel(raycast: Raycast) -> void:
	var placing_position = get_valid_placement(raycast)
	if placing_position == null: return
	
	if Input.is_action_pressed("toggle_diagonal_placement"):
		placing_position = get_diagonal_offset(raycast.collision_point, placing_position, 0.125)
	
	if Voxels.voxel_tool.get_voxel(placing_position) != Voxels.AIR: return
	if collides_with_entity(placing_position, TickClock.player_tick_information.current_voxel): return
	
	Voxels.voxel_tool.set_voxel(placing_position, TickClock.player_tick_information.current_voxel)


# Outlines the block the player is looking at.
func preview_break(raycast: Raycast) -> void:
	preview.visible = false
	if raycast.targeted_voxel_id == Voxels.AIR: return
	
	var variant: BlockVariant = Game.block_library.get_variant(raycast.targeted_variant_id)
	preview.global_position = raycast.targeted_voxel_position + SC.eq_v3(-0.001)
	preview.mesh = variant.get_rotated_mesh_from_voxel(raycast.targeted_voxel_id)
	preview.material_override = break_preview_material
	preview.visible = true


# Creates a preview for what the player would place if they tried to place a block.
func preview_place(raycast: Raycast) -> void:
	preview.visible = false
	
	var preview_position = get_valid_placement(raycast)
	
	if preview_position == null: return
	
	if Input.is_action_pressed("toggle_diagonal_placement"):
		preview_position = get_diagonal_offset(raycast.collision_point, preview_position, diagonal_placement_threshold)
	
	if collides_with_entity(preview_position, TickClock.player_tick_information.current_voxel): return
	if Voxels.voxel_tool.get_voxel(preview_position) != Voxels.AIR: return
	
	var variant: BlockVariant = Game.block_library.get_variant(TickClock.player_tick_information.current_variant)
	preview.global_position = Vector3(preview_position) + SC.eq_v3(-0.001)
	preview.mesh = variant.get_rotated_mesh_from_voxel(TickClock.player_tick_information.current_voxel)
	preview.material_override = place_preview_material 
	preview.visible = true


# Checks if a potential voxel placement would collide with the player.
func collides_with_entity(placement_position: Vector3, voxel_id: int) -> bool:
	var collision_parameters = PhysicsShapeQueryParameters3D.new()
	
	collision_parameters.transform = Transform3D(Basis(), placement_position)
	collision_parameters.shape = Game.block_library.get_variant_from_voxel(voxel_id).get_collision_shape_from_voxel(voxel_id)
	
	return not Game.physics_space.intersect_shape(collision_parameters).is_empty()


# Offsets a placement position depending on the exact collision point.
func get_diagonal_offset(collision_point: Vector3, placement_position: Vector3i, threshold: float) -> Vector3:
	var x_voxel_bounds: Vector2 = Vector2(floor(collision_point.x), ceil(collision_point.x)) + Vector2(threshold, -threshold)
	var y_voxel_bounds: Vector2 = Vector2(floor(collision_point.y), ceil(collision_point.y)) + Vector2(threshold, -threshold)
	var z_voxel_bounds: Vector2 = Vector2(floor(collision_point.z), ceil(collision_point.z)) + Vector2(threshold, -threshold)
	
	var diagonal_offset: Vector3i = Vector3i.ZERO
	diagonal_offset.x = int(collision_point.x > x_voxel_bounds.y) - int(collision_point.x < x_voxel_bounds.x)
	diagonal_offset.y = int(collision_point.y > y_voxel_bounds.y) - int(collision_point.y < y_voxel_bounds.x)
	diagonal_offset.z = int(collision_point.z > z_voxel_bounds.y) - int(collision_point.z < z_voxel_bounds.x)
	
	for i in 3:
		var isolated_offset: Vector3i = Vector3i.ZERO
		isolated_offset[i] = diagonal_offset[i]
		
		if Voxels.is_supported(placement_position + isolated_offset) or not Voxels.is_air(placement_position + isolated_offset):
			diagonal_offset[i] = 0
	
	return placement_position + diagonal_offset


# Returns a valid placement location based on the most recent raycast. Returns null if there is no valid placement.
func get_valid_placement(raycast: Raycast) -> Variant:
	if raycast.targeted_voxel_id != Voxels.AIR: return raycast.targeted_space_position
	for result in SC.reversed_array(raycast.results): if Voxels.is_supported(result): return result
	if midair_placement_enabled: return raycast.targeted_space_position
	return null
