class_name Movement
extends Resource

## A [Resource] that can be used to add movement to a [CharacterBody3D].


@export var enabled: bool = true  ## Controls whether or not any movement functions can be used.
@export var speed: Vector3  ## The maximum speed at which the player moves. As [param speed] is a [Vector3], speed can be different for each axis. The y component is used for gravity if [param gravity] is [code]true[/code].
@export var inertia: Vector3 = Vector3.ONE  ## The rate at which velocity is changed. As [param inertia] is a [Vector3], inertia can be different for each axis.
@export var movement_modifiers: Array[MovementModifier]  ## [MovementModifiers] affect certain aspects of movement, such as speed and inertia. [MovementModifiers] are combined additively.

@export_group("Inputs")
@export var up: StringName  ## The input associated with the +y direction.
@export var down: StringName  ## The input associated with the -y direction.
@export var left: StringName  ## The input associated with the +x direction.
@export var right: StringName  ## The input associated with the -x direction.
@export var forward: StringName  ## The input associated with the +z direction.
@export var backward: StringName  ## The input associated with the -z direction.

@export_group("Falling")
@export var gravity: bool = true  ## Enables gravity when set to [code]true[/code]. Uses the y component of [param speed] for the strength of gravity.
@export var safe_walk: bool = false  ## When set to true, prevents the [CharacterBody3D] from falling off of the edge of a block.

@export_group("Jumping")
@export var jumpSpeed: float  ## The velocity applied to the [CharacterBody3D] when jumping.
#@export var minimumJumpDelay: float  (Unimplimented)

var _speed_modifier: Vector3 = Vector3.ONE
var _inertia_modifier: Vector3 = Vector3.ONE


## Handles movement on all axes. So long as the properties are set appropriately, simply calling movement in [param _physics_process()] will enable movement.
func move(body: CharacterBody3D, collision: CollisionShape3D, delta) -> void:
	var hDirection: Vector2 = Input.get_vector(left, right, forward, backward)
	var vDirection: int
	
	if not gravity:
		vDirection = int(Input.is_action_pressed(up)) - int(Input.is_action_pressed(down))
	elif body.is_on_floor():
		vDirection = 0
	else:
		vDirection = -1
	
	var direction: Vector3 = (body.transform.basis * Vector3(hDirection.x, vDirection, hDirection.y)).normalized()
	
	_apply_modifiers(body)
	
	if direction:
		body.velocity.x = Math.exp_decay(body.velocity.x, direction.x * speed.x * _speed_modifier.x, inertia.x * _inertia_modifier.x, delta)
		body.velocity.y = Math.exp_decay(body.velocity.y, direction.y * speed.y * _speed_modifier.y, inertia.y * _inertia_modifier.y, delta)
		body.velocity.z = Math.exp_decay(body.velocity.z, direction.z * speed.z * _speed_modifier.z, inertia.z * _inertia_modifier.z, delta)
	else:
		body.velocity.x = Math.exp_decay(body.velocity.x, 0, inertia.x * _inertia_modifier.x, delta)
		body.velocity.y = Math.exp_decay(body.velocity.y, 0, inertia.y * _inertia_modifier.y, delta)
		body.velocity.z = Math.exp_decay(body.velocity.z, 0, inertia.z * _inertia_modifier.z, delta)
	
	if safe_walk == true:
		_safe_walk(body, collision)
	
	_speed_modifier = Vector3.ONE
	_inertia_modifier = Vector3.ONE
	
	body.move_and_slide()


## Applies upwards velocity to the player based on [param jumpSpeed] if the [CharacterBody3D] is on the floor.
func jump(body: CharacterBody3D) -> void:
	if body.is_on_floor():
		var tween: Tween = body.create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUART)
		tween.tween_property(body, "velocity:y", 8, 0.075)


func _apply_modifiers(body) -> void:
	for modifier in movement_modifiers:
		if modifier.is_condition_met(body):
			_speed_modifier += modifier.speed_modifier
			_inertia_modifier += modifier.inertia_modifier


func _safe_walk(body: CharacterBody3D, collision: CollisionShape3D) -> void:
	if not body.is_on_floor():
		return
	
	var collision_size: Vector2 = Vector2(collision.shape.size.x, collision.shape.size.z)
	var margin: float = 0.2
	
	var m: float = (collision_size.x / 2) * (1.0 - margin / 2)
	var n: float = (collision_size.y / 2) * (1.0 - margin)
	
	var corners: Array[Vector2] = Math.multiply_v2_array(SC.CORNERS_ARRAY_2D, collision_size / 2)
	var x_positions: Array[Vector2] = Math.multiply_v2_array(SC.CORNERS_ARRAY_2D, Vector2(m, n))
	var z_positions: Array[Vector2] = Math.multiply_v2_array(SC.CORNERS_ARRAY_2D, Vector2(n, m))
	
	var x_blocks: Array[int] = [0, 0, 0, 0]
	var z_blocks: Array[int] = [0, 0, 0, 0]
	
	for i in 4:
		var blockPosition: Vector3 = Vector3.ZERO
		
		blockPosition = body.position + Vector3(x_positions[i].x, -1, x_positions[i].y)
		x_blocks[i] = Voxels.voxel_tool.get_voxel(blockPosition.floor())
		
		blockPosition = body.position + Vector3(z_positions[i].x, -1, z_positions[i].y)
		z_blocks[i] = Voxels.voxel_tool.get_voxel(blockPosition.floor())
		
		blockPosition = body.position + Vector3(corners[i].x, -1, corners[i].y)
		if Voxels.voxel_tool.get_voxel(blockPosition.floor()) != 0:
			corners[i] = Vector2.ZERO
	
	if x_blocks.count(0) == 4 and Math.sum_v2_array(corners).y * body.velocity.z > 0:
		body.velocity.z = 0
	
	if z_blocks.count(0) == 4 and Math.sum_v2_array(corners).x * body.velocity.x > 0:
		body.velocity.x = 0
