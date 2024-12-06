class_name MovementModifier
extends Resource

## A resource used by [Movement] to modify the movement of a [CharacterBody3D].


enum Conditions {
	AIR,  ## Requires the physics body to be on the ground.
	CROUCH,  ## Requires the physics body to be crouching. Used for the player.
}

@export var condition: Conditions  ## Determines which condition is used by [method is_condition_met]. See [enum  Conditions].
@export var speed_modifier: Vector3 = Vector3.ZERO  ## The modifier applied to the speed of the physics body.
@export var inertia_modifier: Vector3 = Vector3.ZERO  ## The modifier applied to the intertia of the physics body.


## Checks if [member condition] is met for the provided [param body].
func is_condition_met(body) -> bool:
	match condition:
		Conditions.AIR: return not body.is_on_floor()
		Conditions.CROUCH: return body.crouching
		_: return false
