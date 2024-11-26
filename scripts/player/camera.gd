extends Camera3D


@export var player: CharacterBody3D


func get_direction_vector() -> Vector3:
	return -(player.basis * self.basis).z.normalized()
