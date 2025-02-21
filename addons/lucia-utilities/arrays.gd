class_name Arrays
extends RefCounted


static func from_vec2(vector: Vector2) -> Array:
	return [vector.x, vector.y]


static func from_vec3(vector: Vector3) -> Array:
	return [vector.x, vector.y, vector.z]


static func from_vec4(vector: Vector4) -> Array:
	return [vector.w, vector.x, vector.y, vector.z]


static func to_vec2(array: Array[float]) -> Vector2:
	if array.size() < 2: return Vector2()
	return Vector2(array[0], array[1])


static func to_vec3(array: Array[float]) -> Vector3:
	if array.size() < 2: return Vector3()
	return Vector3(array[0], array[1], array[2])


static func to_vec4(array: Array[float]) -> Vector4:
	if array.size() < 2: return Vector4()
	return Vector4(array[0], array[1], array[2], array[3])
