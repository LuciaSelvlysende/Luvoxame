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


static func fill_unique(array: Array, value: Variant) -> Array:
	var valid_types: Array = [
		TYPE_ARRAY,
		TYPE_DICTIONARY,
		TYPE_OBJECT,
		TYPE_PACKED_BYTE_ARRAY,
		TYPE_PACKED_COLOR_ARRAY,
		TYPE_PACKED_FLOAT32_ARRAY,
		TYPE_PACKED_FLOAT64_ARRAY,
		TYPE_PACKED_INT32_ARRAY,
		TYPE_PACKED_INT64_ARRAY,
		TYPE_PACKED_STRING_ARRAY,
		TYPE_PACKED_VECTOR2_ARRAY,
		TYPE_PACKED_VECTOR3_ARRAY,
		TYPE_PACKED_VECTOR4_ARRAY,
	]
	
	if not valid_types.has(typeof(value)):
		push_warning("Param 'value' does not have a duplicate() method.")
		return array
	
	for i in array.size():
		array[i] = value.duplicate()
	
	return array


static func push_front_array(array_a: Array, array_b: Array) -> void:
	for element in array_b:
		array_a.push_front(element)


## Equivalent to [method Array.reverse], but actually returns the reversed array.
static func reversed(array: Array) -> Array:
	var result: Array = array.duplicate()
	result.reverse()
	return result


## Merges an Array of Arrays into a single Array. The type of [param array] should be Array of Arrays, but for whatever reason that causes errors.
static func merged_nested(array: Array) -> Array:
	var merged_array: Array = []
	
	for nested_array in array:
		merged_array += nested_array
	
	return merged_array


## Erases all values of [array_b] from [param array_a] if present.
static func erase_array(array_a: Array, array_b: Array) -> Array:
	for element in array_b:
		array_a.erase(element)
	
	return array_a


## If [param has_all] is [code]true[/code], checks if array_a has [b]all[/b] values of [param array_b]. Otherwise, checks if array_a has [b]any[/b] values of [param array_b].
static func has_array(array_a: Array, array_b: Array, has_all: bool = true) -> bool:
	for element in array_b.duplicate():
		if array_a.has(element): continue
		if has_all: return false
		array_b.erase(element)
	
	return true if has_all else not array_b.is_empty()


static func wrap_index(array: Array, index: int) -> int:
	if not array: return 0
	return (index % array.size() + array.size()) % array.size()
