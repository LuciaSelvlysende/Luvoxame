class_name RaycastBase
extends Resource


## A raycasting algorithm that is designed to be used for voxel-based games.

# Explanation: https://docs.google.com/document/d/1xIoU_lWxvgCYzRTifh26WUQg0bS2AiT5F1LRvnt1kIQ/edit?usp=sharing

# Note: This is designed for use with integer-aligned 1x1x1 voxels. It will likely need modification for other uses.


@export var results: Array[Vector3i] = []  ## A list of voxel spaces that the ray passed through.
@export var collision_point: Vector3  ## The exact point of collision.
@export var collision_normal: Vector3  ## The normal vector of the collision.


## Preforms a raycast, starting at [param origin], extending in [param direction], until the distance it has travelled is greater than or equal to [param length].
func raycast(origin: Vector3, direction: Vector3, length: float) -> void:
	_reset()
	
	# Integers are incompatible, this removes them.
	for i in 3: if origin[i] == int(origin[i]):  
		origin[i] += direction[i] * 0.01
	
	# Record starting voxel (raycast would otherwise skip it).
	results.append(origin.floor() as Vector3i)
	
	while length > 0:
		var increment_result: IncrementResult = _increment_voxel(origin, direction)
		
		if _precise_condition():
			increment_result = _increment_precise(origin, increment_result)
		
		# Set up for next iteration.
		length -= origin.distance_to(increment_result.position)
		origin = increment_result.position - increment_result.normal * 0.01
		
		# Record results.
		results.append(origin.floor() as Vector3i)
		collision_point = increment_result.position
		collision_normal = increment_result.normal
		
		if _stop_condition(): return


# Resets the raycast, to prevent an old raycast result being merged with a new one.
func _reset() -> void:
	collision_point = Vector3.ZERO
	collision_normal = Vector3.ZERO
	results.clear()


# Increments the ray by one voxel space, regardless of what occupies that space. Should be used for "full blocks".
# See the explanation doc above for details.
func _increment_voxel(origin: Vector3, direction: Vector3):
	var face_candidates = origin.floor() + direction.sign().clamp(Vector3.ZERO, Vector3.ONE)
	var distance: Vector3 = Vector3.ZERO
	var exit_position: Vector3 = Vector3.ZERO
	
	for i in 3:
		distance[i] = (face_candidates[i] - origin[i]) / direction[i]
		
		for j in 3:
			exit_position[j] = origin[j] + distance[i] * direction[j]
			exit_position[j] = 0 if is_zero_approx(exit_position[j]) else exit_position[j]  # Addresses -0 edge case.
		
		if not Math.vector3_is_within_range(exit_position, origin.floor(), origin.ceil()): continue
		return IncrementResult.create(exit_position, Vector3(1 if i == 0 else 0, 1 if i == 1 else 0, 1 if i == 2 else 0) * -direction.sign())


# Precisily increments the ray by up to one voxel. Will be able to collide with whatever shape occupies that voxel space. 
# Should be used for "partial blocks", such as stairs or slabs.
func _increment_precise(origin: Vector3, increment_result: IncrementResult) -> Variant:
	var ray_parameters: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_parameters.from = origin + collision_normal * 0.015
	ray_parameters.to = increment_result.position
	
	var ray_result: Dictionary = Game.physics_space.intersect_ray(ray_parameters)
	return increment_result if ray_result.is_empty() else IncrementResult.create(ray_result["position"], ray_result["normal"]) 


# Determines whether or not a raycast increment should use _increment_precise().
func _precise_condition() -> bool:
	return false  # Replace with an actual condition (such as true for partial blocks, false for full blocks/air).


# Determines whether or not the raycast should stop prematurely.
func _stop_condition() -> bool:
	return false  # Replace with an actual condition.
	
	# Use something like this if _precise_condition() is NOT defined:
	#	 If previous result is not air, return true, else return false.
	
	# Use something like this if _precise_condition() IS defined:
	#	 If previous result is the same as the result before it, return true. This detects collision from _increment_precise().
	#	 If previous result is a partial block, return false. This allows _precise_condition to get a chance to check for partial blocks.
	#	 If previous result is not air, return true, else return false.


## Package for the result of each increment of a raycast.
class IncrementResult:
	var position: Vector3  ## For _voxel_increment(), the point at which the ray left the current voxel space. For _precise_increment(), this is the collision point.
	var normal: Vector3  ## The normal vector of the collision.
	
	## Shortcut function for creating an IncrementResult and assigning values for [param position] and [param normal].
	static func create(position: Vector3, normal: Vector3) -> IncrementResult:
		var increment_result: IncrementResult = IncrementResult.new()
		increment_result.position = position
		increment_result.normal = normal
		return increment_result
