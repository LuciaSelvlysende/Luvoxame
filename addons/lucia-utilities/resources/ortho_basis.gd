class_name OrthoBasis
extends Resource


@export var rotations: Vector3i
@export var reflections: Vector3i


func _init(assign_rotations: Vector3i = Vector3i.ZERO, assign_reflections: Vector3i = Vector3i.ZERO) -> void:
	rotations = assign_rotations
	reflections = assign_reflections


func get_basis() -> Basis:
	var basis: Basis = Basis()
	
	basis.rotated(Vector3.RIGHT, rotations.x * TAU * 0.25)
	basis.rotated(Vector3.UP, rotations.y * TAU * 0.25)
	basis.rotated(Vector3.BACK, rotations.z * TAU * 0.25)
	
	basis.x * -Vectors.bool(reflections.x)
	basis.y * -Vectors.bool(reflections.y)
	basis.z * -Vectors.bool(reflections.z)
	
	return basis
