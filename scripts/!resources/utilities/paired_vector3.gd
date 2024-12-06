class_name PairedVector3
extends Resource

## WIP


@export var x: Vector3 = Vector3.ZERO
@export var y: Vector3 = Vector3.ZERO


static func create(x: Vector3, y: Vector3) -> PairedVector3:
	var paired_vector3: PairedVector3 = PairedVector3.new()
	paired_vector3.x = x
	paired_vector3.y = y
	return paired_vector3


func lerp(weight: Vector3):
	var result: Vector3 = Vector3.ZERO
	
	for i in 3:
		result[i] = lerp(x[i], y[i], weight[i])
	
	return result
