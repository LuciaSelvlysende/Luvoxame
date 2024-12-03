class_name Entity
extends CharacterBody3D


@export var do_movement: bool = true
@export var camera: Camera3D

@export_group("Parameters")
@export var max_speed: float = 20
@export var max_speed_distribution: PairedVector3 = PairedVector3.create(Vector3(1, 0, 1), Vector3(1, 0, 1))
@export var acceleration: float = 1
@export var acceleration_distribution: PairedVector3 = PairedVector3.create(Vector3(1, 1, 1), Vector3(1, 1, 0.1))
@export var deceleration: float = 1
@export var deceleration_distribution: PairedVector3 = PairedVector3.create(Vector3(1, 1, 1), Vector3(1, 1, 1))

@export_group("Inputs")
@export var up: StringName  ## The input associated with the +y direction.
@export var down: StringName  ## The input associated with the -y direction.
@export var right: StringName  ## The input associated with the +x direction.
@export var left: StringName  ## The input associated with the -x direction.
@export var backward: StringName  ## The input associated with the +z direction.
@export var forward: StringName  ## The input associated with the -z direction.


func _process(delta: float) -> void:
	if not do_movement: return
	
	print(Basis.looking_at(get_direction()) * (acceleration * acceleration_distribution.lerp(get_direction_weight()).normalized()))
	velocity += get_acceleration() - get_deceleration()
	velocity = velocity.clamp(-get_max_velocity(), get_max_velocity()).snapped(get_deceleration())

	move_and_slide()


# THIS IS THE PROBLEM
func get_max_velocity() -> Vector3:
	return max_speed * max_speed_distribution.lerp(get_direction_weight()).normalized()


func get_acceleration() -> Vector3:
	return acceleration * acceleration_distribution.lerp(get_direction_weight()) * get_direction()


func get_deceleration() -> Vector3:
	return deceleration * deceleration_distribution.lerp(get_direction_weight()) * (velocity.sign() * Vectors.bool(get_direction(), true)).normalized()


func get_local_direction() -> Vector3:
	var local_direction: Vector3 = Vector3.ZERO

	local_direction.x += int(Input.is_action_pressed(right)) if InputMap.has_action(right) else 0
	local_direction.x -= int(Input.is_action_pressed(left)) if InputMap.has_action(left) else 0

	local_direction.y += int(Input.is_action_pressed(up)) if InputMap.has_action(up) else 0
	local_direction.y -= int(Input.is_action_pressed(down)) if InputMap.has_action(down) else 0

	local_direction.z += int(Input.is_action_pressed(backward)) if InputMap.has_action(backward) else 0
	local_direction.z -= int(Input.is_action_pressed(forward)) if InputMap.has_action(forward) else 0
	
	return local_direction.normalized()


func get_direction() -> Vector3:
	return basis * get_local_direction()


func get_direction_weight() -> Vector3:
	return Vectors.map(get_local_direction().sign(), -Vector3.ONE, Vector3.ONE)
