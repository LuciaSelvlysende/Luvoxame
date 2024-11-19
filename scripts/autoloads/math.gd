class_name MathAutoload
extends Node

## Autoload that holds various math-related helper functions.


## Exponential decay function, essentially an improved version of the lerp() function.
func exp_decay(initial, final, rate, delta) -> Variant:
	rate *= 10
	return final + (initial - final) * exp(-rate * delta)


## Rotates a mesh around a pivot by rotating all of it's vertices.
func rotate_mesh(mesh: Mesh, rotation: Quaternion, pivot: Vector3) -> ArrayMesh:
	var rotated_mesh: ArrayMesh = mesh.duplicate()
	
	# There is no built-in method of ArrayMesh that allows a surface to be replaced, so the
	# surfaces are copied and cleared. New surfaces are added onto a blank slate.
	
	var surfaces: Array[Array] = []
	
	for surface_index in rotated_mesh.get_surface_count():
		surfaces.append(rotated_mesh.surface_get_arrays(surface_index))
	
	rotated_mesh.clear_surfaces()
	
	for surface in surfaces:
		for array_index in surface.size():
			var vertex_array = surface[array_index]
			
			if vertex_array == null:
				continue
			
			if typeof(vertex_array[0]) != TYPE_VECTOR3:
				continue
			
			for vertex_index in vertex_array.size():
				var vertex = vertex_array[vertex_index]
				
				vertex_array[vertex_index] = rotate_point(vertex, rotation, pivot)
		
		rotated_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface)
	
	return rotated_mesh


## Rotates a point around a pivot.
func rotate_point(point: Vector3, rotation: Quaternion, pivot: Vector3) -> Vector3:
	if rotation.get_axis() == Vector3.ZERO:
		return point
	
	point -= pivot
	
	rotation = Quaternion(rotation.get_axis().normalized(), deg_to_rad(rotation.w))
	point *= rotation
	
	point += pivot
	
	return point


## Replaces all occurances of [param target_value] in [param vector] with [param replace_value].
func replace_v2(vector: Vector2, target_value: float, replace_value: float) -> Vector2:
	for i in 2:
		vector[i] = replace_value if vector[i] == target_value else vector[i]
	
	return vector


## Replaces all occurances of [param target_value] in [param vector] with [param replace_value].
func replace_v3(vector: Vector3, target_value: float, replace_value: float) -> Vector3:
	for i in 2:
		vector[i] = replace_value if vector[i] == target_value else vector[i]
	
	return vector


## Checks if a [Vector2] is within a certain range and returns the appropriate [bool].
func v2_is_within_range(value: Vector2, range_min: Vector2, range_max: Vector2) -> bool:
	for i in 2:
		if abs(value[i] - clamp(value[i], range_min[i], range_max[i])) > 0.0001:
			return false
	
	return true


## Checks if a [Vector3] is within a certain range and returns the appropriate [bool].
func v3_is_within_range(value: Vector3, range_min: Vector3, range_max: Vector3) -> bool:
	for i in 3:
		if abs(value[i] - clamp(value[i], range_min[i], range_max[i])) > 0.0001:
			return false
	
	return true

# --------------------------------------------------------------------------------------------------
# VECTOR ARRAY MATH 
# --------------------------------------------------------------------------------------------------

## Returns the absolute value of all values in an [Array] of [Vector2]s.
func abs_v2_array(array: Array[Vector2]) -> Array[Vector2]:
	var abs_array: Array[Vector2] = []
	for vector in array:
		abs_array.append(vector.abs())
	
	return abs_array


## Returns the absolute value of all values in an [Array] of [Vector3]s.
func abs_v3_array(array: Array[Vector3]) -> Array[Vector3]:
	var abs_array: Array[Vector3] = []
	for vector in array:
		abs_array.append(vector.abs())
	
	return abs_array


## Returns the average of an [Array] of [Vector2]s.
func avg_v2_array(array: Array[Vector2]) -> Vector2:
	return sum_v2_array(array) / array.size()


## Returns the average of an [Array] of [Vector3]s.
func avg_v3_array(array: Array[Vector3]) -> Vector3:
	return sum_v3_array(array) / array.size()


## Multiplies all values in an [Array] of [Vector2]s by the provided [param multiplier].
func multiply_v2_array(array: Array[Vector2], multiplier: Variant) -> Array[Vector2]:
	var multiplied_array: Array[Vector2] = []
	for vector in array:
		multiplied_array.append(vector * multiplier)
	
	return multiplied_array


## Multiplies all values in an [Array] of [Vector3]s by the provided [param multiplier].
func multiply_v3_array(array: Array[Vector3], multiplier: Variant) -> Array[Vector3]:
	var multiplied_array: Array[Vector3] = []
	for vector in array:
		multiplied_array.append(vector * multiplier)
	
	return multiplied_array


## Calculates the sum of all values in an [Array] of [Vector2]s.
func sum_v2_array(array: Array[Vector2]) -> Vector2:
	var sum: Vector2 = Vector2.ZERO
	for vector in array:
		sum += vector
	
	return sum


## Calculates the sum of all values in an [Array] of [Vector3]s.
func sum_v3_array(array: Array[Vector3]) -> Vector3:
	var sum: Vector3 = Vector3.ZERO
	for vector in array:
		sum += vector
	
	return sum
