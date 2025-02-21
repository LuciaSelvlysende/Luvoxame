class_name Entity
extends CharacterBody3D


@export var id: StringName

@export_group("Movement")
@export var do_movement: bool = true
@export var speed: float = 20
@export var acceleration: float = 1
@export var deceleration: float = 0.5
@export var distribution: Matrix2D = Matrix2D.new(Vector2i(3, 2), TYPE_FLOAT, [1.0, 1.0, 1.0, 1.0, 1.0, 1.0])

@export_group("Actions")  # TODO: Move to EntityProperty "Controllable".
@export var up: StringName
@export var down: StringName
@export var right: StringName
@export var left: StringName
@export var backward: StringName
@export var forward: StringName

@export_group("Node Connections")
@export var camera: Camera3D


func _process(_delta: float) -> void:
	if not do_movement: return

	var delta_velocity: Vector3 = get_acceleration() - get_deceleration()
	delta_velocity = delta_velocity.normalized() * clamp(delta_velocity.length(), 0, abs(speed - (velocity + delta_velocity).length()))
	velocity += delta_velocity
	velocity = velocity.normalized() * clamp(velocity.length(), 0, get_speed())  # TODO: Add distribution support.

	move_and_slide()


func get_speed() -> float:
	return Vectors.max(get_distribution(basis.inverse() * velocity) * Vectors.bool(velocity)) * speed


func get_acceleration() -> Vector3:
	var direction: Vector3 = get_input_direction()
	
	return basis * (
		(get_distribution(direction) * direction).normalized()
		* Vectors.max(get_distribution(direction) * Vectors.bool(direction))
		* acceleration
	)


func get_deceleration() -> Vector3:
	return velocity.normalized() * deceleration


func get_distribution(direction: Vector3) -> Vector3:
	var weight: Array[float] = []
	weight.assign(Arrays.from_vec3(Vectors.map(direction.sign(), -Vector3.ONE, Vector3.ONE)))
	
	var distribution_array: Array[float] = []
	distribution_array.assign(distribution.flatten(0, Matrix2D.FlattenModes.LERP_BOTH, weight))
	
	return Arrays.to_vec3(distribution_array)


func get_input_direction() -> Vector3:  # TODO: Move to EntityProperty "Controllable".
	var input_direction: Vector3 = Vector3.ZERO

	input_direction.x += int(Input.is_action_pressed(right)) if InputMap.has_action(right) else 0
	input_direction.x -= int(Input.is_action_pressed(left)) if InputMap.has_action(left) else 0

	input_direction.y += int(Input.is_action_pressed(up)) if InputMap.has_action(up) else 0
	input_direction.y -= int(Input.is_action_pressed(down)) if InputMap.has_action(down) else 0

	input_direction.z += int(Input.is_action_pressed(backward)) if InputMap.has_action(backward) else 0
	input_direction.z -= int(Input.is_action_pressed(forward)) if InputMap.has_action(forward) else 0

	return input_direction.normalized()
