class_name MovementModifier
extends Resource

enum CONDITIONS {
	AIR,
	CROUCH,
}

@export var condition: CONDITIONS
@export var speed_modifier: Vector3 = Vector3.ZERO
@export var inertia_modifier: Vector3 = Vector3.ZERO


func is_condition_met(body) -> bool:
	match condition:
		CONDITIONS.AIR:
			return not body.is_on_floor()
		
		CONDITIONS.CROUCH:
			return body.crouching
	
	return false
