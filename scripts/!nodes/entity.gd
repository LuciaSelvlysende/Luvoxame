class_name Entity
extends CharacterBody3D


@export var do_movement: bool = true
@export var camera: Camera3D

@export_group("Parameters")
@export var speed: float = 20
@export var speed_distribution: PairedVector3 = PairedVector3.create(Vector3(1, 1, 1), Vector3(1, 1, 1))
@export var acceleration: float = 1
@export var acceleration_distribution: PairedVector3 = PairedVector3.create(Vector3(1, 1, 1), Vector3(1, 1, 1))
@export var deceleration: float = 1
@export var deceleration_distribution: PairedVector3 = PairedVector3.create(Vector3(1, 1, 1), Vector3(1, 1, 0.1))

@export_group("Inputs")
@export var up: StringName  ## The input associated with the +y direction.
@export var down: StringName  ## The input associated with the -y direction.
@export var right: StringName  ## The input associated with the +x direction.
@export var left: StringName  ## The input associated with the -x direction.
@export var backward: StringName  ## The input associated with the +z direction.
@export var forward: StringName  ## The input associated with the -z direction.


func _process(_delta: float) -> void:
	if not do_movement: return
	
	#print(velocity, get_acceleration(), -get_deceleration(), get_deceleration_distribution())
	velocity += get_acceleration() - get_deceleration()
	velocity = velocity.normalized() * clamp(velocity.length(), 0, speed)

	move_and_slide()


func get_velocity_bounds() -> Vector3:
	return Vector3.ZERO


func get_acceleration() -> Vector3:
	var current_acceleration: Vector3
	
	current_acceleration = (get_acceleration_distribution() * get_local_direction()).normalized()
	current_acceleration *= Vectors.max(get_acceleration_distribution() * Vectors.bool(get_local_direction()))
	current_acceleration *= acceleration
	
	return basis * current_acceleration


func get_deceleration() -> Vector3:
	var current_deceleration: Vector3 = basis * (get_deceleration_distribution() * Vectors.bool(velocity))
	
	for i in 3:
		if get_direction()[i] == 0: continue
		if sign(get_direction()[i]) != sign(current_deceleration[i]): continue
		current_deceleration[i] = 0
	
	var current_deceleration_direction: Vector3 = current_deceleration.normalized()
	var current_deceleration_length: float = abs(Vectors.max(current_deceleration, true))
	current_deceleration = (deceleration * current_deceleration_direction * current_deceleration_length)
	print(velocity, current_deceleration)

	for i in 3:
		var clamp_min: float = 0 if velocity[i] > 0 else velocity[i]
		var clamp_max: float = 0 if velocity[i] < 0 else velocity[i]
		current_deceleration[i] = clamp(current_deceleration[i], clamp_min, clamp_max)
	
	return current_deceleration


func get_speed_distribution() -> Vector3:
	var weight: Vector3 = Vectors.map(get_local_direction().sign(), -Vector3.ONE, Vector3.ONE)
	return speed_distribution.lerp(weight)


func get_acceleration_distribution() -> Vector3:
	var weight: Vector3 = Vectors.map(get_local_direction().sign(), -Vector3.ONE, Vector3.ONE)
	return acceleration_distribution.lerp(weight)


func get_deceleration_distribution() -> Vector3:
	var weight: Vector3 = Vectors.map((basis.inverse() * velocity).sign(), -Vector3.ONE, Vector3.ONE)
	return deceleration_distribution.lerp(weight)


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
