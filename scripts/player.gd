extends CharacterBody3D


@export var speed: float = 5
@export var sensitivity: float
@export var camera: Camera3D
@export var collision: CollisionShape3D

var raycast: VoxelRaycast = VoxelRaycast.new()


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	collision.global_rotation = Vector3.ZERO
	
	var direction: Vector3 = Vector3(
		int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		int(Input.is_action_pressed("up")) - int(Input.is_action_pressed("down")),
		int(Input.is_action_pressed("back")) - int(Input.is_action_pressed("forward"))
	)
	
	velocity = basis * direction.normalized() * speed * delta * 60
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.screen_relative.x * sensitivity * 0.00004
		camera.rotation.x -= event.screen_relative.y * sensitivity * 0.00004
		camera.rotation.x = clamp(camera.rotation.x, -TAU/4, +TAU/4)
	
	if event.is_action_pressed("break") or event.is_action_pressed("place"):
		raycast.raycast(camera.global_position, -camera.global_basis.z.normalized(), 5)
		
		if event.is_action_pressed("break") and raycast.voxels.size() > 0:
			VoxelTools.set_voxel(raycast.voxels.back(), 0)
		
		if event.is_action_pressed("place") and raycast.voxels.size() > 1:
			if VoxelTools.is_air(raycast.voxels.back()):
				VoxelTools.set_voxel(raycast.voxels.back(), 1)
			else:
				VoxelTools.set_voxel(raycast.voxels[-2], 1)
