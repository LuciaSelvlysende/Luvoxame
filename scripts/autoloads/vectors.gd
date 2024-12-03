class_name VectorsAutoload
extends Node



## Returns [param vector] where each component has been converted to a numerical boolean (0 if 0, 1 if anything else). [param invert] will swap the the results, similar to the "not" keyword.
func bool(vector, invert: bool = false) -> Variant:
	if invert and vector is Vector2 or vector is Vector2i:
		return Vector2.ONE - vector.sign().abs()
	if invert and vector is Vector3 or vector is Vector3i:
		return Vector3.ONE - vector.sign().abs()
	if invert and vector is Vector4 or vector is Vector4i:
		return Vector4.ONE - vector.sign().abs()
	
	return vector.sign().abs()


## Returns a [Vector2] where all components are equal to the provided [param value].
func eq2(value: float) -> Vector2:
	return Vector2(value, value)


## Returns a [Vector3] where all components are equal to the provided [param value].
func eq3(value: float) -> Vector3:
	return Vector3(value, value, value)


##
func map(vector, from_min, from_max, to_min = null, to_max = null) -> Variant:
	# Assign default values for to_min and to_max based on type.
	if vector is Vector2 or vector is Vector2i:
		to_min = Vector2.ZERO
		to_max = Vector2.ONE
	if vector is Vector3 or vector is Vector3i:
		to_min = Vector3.ZERO
		to_max = Vector3.ONE
	if vector is Vector4 or vector is Vector4i:
		to_min = Vector4.ZERO
		to_max = Vector4.ONE
	
	if to_min == null or to_max == null: return vector
	
	var fractional_distance = (vector - from_min) / (from_max - from_min)
	return fractional_distance * (to_max - to_min) + to_min


## Replaces all occurances of [param target_value] in [param vector] with [param replace_value].
func replace(vector, target_value: float, replace_value: float) -> Variant:
	for i in get_vector_size(vector):
		if vector[i] == target_value:
			vector[i] = replace_value
	
	return vector


## Checks if a [Vector2] is within a certain range and returns the appropriate [bool].
func is_within_range(vector: Vector3, range_min: Vector3, range_max: Vector3) -> bool:
	for i in get_vector_size(vector):
		if abs(vector[i] - clamp(vector[i], range_min[i], range_max[i])) > 0.0001:
			return false
	
	return true


## Determines how many components are in an unknown vector.
func get_vector_size(vector) -> int:
	if vector is Vector2 or vector is Vector2i: return 2
	if vector is Vector3 or vector is Vector3i: return 3
	if vector is Vector4 or vector is Vector4i: return 4
	return 0


# --------------------------------------------------------------------------------------------------
# VECTOR ARRAY MATH 
# --------------------------------------------------------------------------------------------------

## Returns the absolute value of all values in an [Array] of Vectors.
func abs_array(array: Array) -> Array:
	var abs_array: Array = []
	for vector in array:
		abs_array.append(vector.abs())
	
	return abs_array


## Returns the average of an [Array] of Vectors.
func get_array_mean(array: Array) -> Variant:
	return sum_array(array) / array.size()


## Multiplies all values in an [Array] of Vectors by the provided [param multiplier].
func multiply_array(array: Array, multiplier) -> Array:
	var multiplied_array: Array = []
	for vector in array:
		multiplied_array.append(vector * multiplier)
	
	return multiplied_array


## Calculates the sum of all values in an [Array] of [Vector2]s.
func sum_array(array: Array) -> Variant:
	var sum = array.front()
	
	for vector in array:
		if vector == array.front(): continue
		sum += vector
	
	return sum
