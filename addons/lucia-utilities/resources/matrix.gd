class_name Matrix2D
extends Resource


enum FlattenModes {
	AVERAGE,
	LERP_POSITION,
	LERP_VALUE,
	LERP_BOTH,
}

@export var size: Vector2i = Vector2i(2, 2)
@export var data: Array = [0.0, 0.0, 0.0, 0.0]
@export var type: Variant.Type = TYPE_FLOAT


func _init(init_size: Vector2i, init_type: Variant.Type = TYPE_FLOAT, init_data: Array = []) -> void:
	size.x = init_size.x
	size.y = init_size.y
	type = init_type
	data.resize(size.x * size.y)
	
	if init_data.size() == data.size():
		data = init_data
		return
	
	match type:
		TYPE_NIL: data.fill(null)
		TYPE_BOOL: data.fill(bool())
		TYPE_INT: data.fill(int())
		TYPE_FLOAT: data.fill(float())
		TYPE_STRING: data.fill(String())
		TYPE_VECTOR2: data.fill(Vector2())
		TYPE_VECTOR2I: data.fill(Vector2i())
		TYPE_RECT2: data.fill(Rect2())
		TYPE_RECT2I: data.fill(Rect2i())
		TYPE_VECTOR3: data.fill(Vector3())
		TYPE_VECTOR3I: data.fill(Vector3i())
		TYPE_TRANSFORM2D: data.fill(Transform2D())
		TYPE_VECTOR4: data.fill(Vector4())
		TYPE_VECTOR4I: data.fill(Vector4i())
		TYPE_PLANE: data.fill(Plane())
		TYPE_QUATERNION: data.fill(Quaternion())
		TYPE_AABB: data.fill(AABB())
		TYPE_BASIS: data.fill(Basis())
		TYPE_TRANSFORM3D: data.fill(Transform3D())
		TYPE_PROJECTION: data.fill(Projection())
		TYPE_COLOR: data.fill(Color())
		TYPE_STRING_NAME: data.fill(StringName())
		TYPE_NODE_PATH: data.fill(NodePath())
		TYPE_RID: data.fill(RID())
		TYPE_OBJECT: data.fill(null)
		TYPE_CALLABLE: data.fill(Callable())
		TYPE_SIGNAL: data.fill(Signal())
		TYPE_DICTIONARY: data.fill(Dictionary())
		TYPE_ARRAY: data.fill(Array())
		TYPE_PACKED_BYTE_ARRAY: data.fill(PackedByteArray())
		TYPE_PACKED_INT32_ARRAY: data.fill(PackedInt32Array())
		TYPE_PACKED_INT64_ARRAY: data.fill(PackedInt64Array())
		TYPE_PACKED_FLOAT32_ARRAY: data.fill(PackedFloat32Array())
		TYPE_PACKED_FLOAT64_ARRAY: data.fill(PackedFloat64Array())
		TYPE_PACKED_STRING_ARRAY: data.fill(PackedStringArray())
		TYPE_PACKED_VECTOR2_ARRAY: data.fill(PackedVector2Array())
		TYPE_PACKED_VECTOR3_ARRAY: data.fill(PackedVector3Array())
		TYPE_PACKED_COLOR_ARRAY: data.fill(PackedColorArray())
		TYPE_PACKED_VECTOR4_ARRAY: data.fill(PackedVector4Array())


func access(position_x: int, position_y: int) -> Variant:
	return data[position_x + position_y * size.x]


func access_array(axis: int, position: int) -> Array:
	if not [0, 1].has(axis): return []
	
	var result: Array = []
	result.resize(size[axis])
	
	for i in size[axis]:
		result[i] = access(position, i) if axis else access(i, position)
	
	return result


func flatten(axis: int, mode: FlattenModes, weights: Array[float]) -> Array:
	if not [0, 1].has(axis): return []
	
	var result: Array = []
	result.resize(size[axis])
	
	for i in size[axis]:
		var array: Array = access_array(int(not axis), i)
		
		match mode:
			FlattenModes.AVERAGE:
				result[i] = Vectors.get_array_mean(access_array(int(not axis), i))
			FlattenModes.LERP_POSITION:
				result[i] = array[round(weights[i] * (size[int(not axis)] - 1))]
			FlattenModes.LERP_VALUE:
				result[i] = lerp(array.min(), array.max(), weights[i])
			FlattenModes.LERP_BOTH:
				var weight: float = weights[i] * (size[int(not axis)] - 1)
				result[i] = lerp(array[floor(weight)], array[ceil(weight)], weight - floor(weight))
	
	return result
