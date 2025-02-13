class_name Math
extends RefCounted

## Autoload that holds various math-related helper functions.


## 
static func map(value: float, from_min: float, from_max: float, to_min: float = 0.0, to_max: float = 1.0) -> float:
	var fractional_distance = (value - from_min) / (from_max - from_min)
	return fractional_distance * (to_max - to_min) + to_min


## Exponential decay function, essentially an improved version of the lerp() function.
static func exp_decay(initial, final, rate, delta) -> Variant:
	rate *= 10
	return final + (initial - final) * exp(-rate * delta)


## Rotates a mesh around a pivot by rotating all of it's vertices.
static func rotate_mesh(mesh: Mesh, basis: Basis, pivot: Vector3) -> ArrayMesh:
	var rotated_mesh: ArrayMesh = mesh.duplicate()
	
	# There is no built-in method of ArrayMesh that allows a surface to be replaced, so the
	# surfaces are copied and cleared. New surfaces are added onto a blank slate.
	
	var surfaces: Array[Array] = []
	
	for surface_index in rotated_mesh.get_surface_count():
		surfaces.append(rotated_mesh.surface_get_arrays(surface_index))
	
	rotated_mesh.clear_surfaces()
	
	for surface in surfaces: for array_index in surface.size():
		var vertex_array = surface[array_index]
		
		if vertex_array == null: continue
		if typeof(vertex_array[0]) != TYPE_VECTOR3: continue
		
		for vertex_index in vertex_array.size():
			vertex_array[vertex_index] = rotate_point(vertex_array[vertex_index], basis, pivot)
		
		rotated_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface)
	
	return rotated_mesh


## Rotates a point around a pivot.
static func rotate_point(point: Vector3, basis: Basis, pivot: Vector3) -> Vector3:
	point -= pivot
	
	point *= basis
	
	point += pivot
	
	return point
