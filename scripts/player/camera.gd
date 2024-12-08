class_name PlayerCamera_Lvx
extends Camera3D

## Script for the players camera.


@export_group("Node Connections")
@export var player: CharacterBody3D  ## Node reference for the player.


## Returns the direction vector for the player. Note that this is different from a rotation. It is the point that is exactly 1 meter in front of where the player is facing. 
func get_direction_vector() -> Vector3:
	return -(player.basis * self.basis).z.normalized()
