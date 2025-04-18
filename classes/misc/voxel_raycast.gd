class_name VoxelRaycast
extends Resource


var voxels: Array[Vector3i] = []
var collision_normal: Vector3
var collision_point: Vector3
var data: Dictionary = {}  # Dictionary[StringName, Array]


func _init(origin: Vector3 = Vector3.ZERO, direction: Vector3 = Vector3.ZERO, length: float = 0.0) -> void:
	if direction == Vector3.ZERO or length == 0.0: return
	raycast(origin, direction, length)


func raycast(origin: Vector3, direction: Vector3, length: float) -> void:
	voxels.clear()
	
	var axis: int = 0
	var voxel: Vector3i = origin.floor()
	var voxel_delta: Vector3i = direction.sign()
	var distance: float = 0.0
	var delta: Vector3 = Vector3.ONE / direction.abs()
	var distance_max: Vector3 = delta * origin.posmodv(-voxel_delta).abs()
	
	data = {
		"inputs" = [origin, direction, length],
		"constants" = [voxel_delta, distance_max],
		"increments" = []
		}
	
	while distance < length:
		axis = distance_max.min_axis_index()
		
		distance = distance_max[axis]
		distance_max[axis] += delta[axis]
		
		voxel[axis] += voxel_delta[axis]
		voxels.append(voxel)
		
		data.increments.append(IncrementData.new([axis, voxel, distance, distance_max]))
		
		if _stop_condition(): break
	
	collision_normal = -direction.sign() * (Vector3.RIGHT if axis == 0 else Vector3.UP if axis == 1 else Vector3.BACK)
	collision_point = origin + distance * direction


func _stop_condition() -> bool:
	return not BlockTool.is_air(voxels.back())


class IncrementData:
	var axis: int
	var voxel: Vector3i
	var distance: float
	var distance_max: Vector3
	
	func _init(params: Array) -> void:
		axis = params[0]
		voxel = params[1]
		distance = params[2]
		distance_max = params[3]


####################################################################################################
# LUVOXAME HELPERS
####################################################################################################


func get_target_solid() -> Vector3i:
	for increment in data.increments:
		if BlockTool.is_air(increment.voxel): continue
		return increment.voxel
	
	return Vector3i(INF, INF, INF)


func get_target_empty() -> Vector3i:
	for increment in data.increments:
		if BlockTool.is_air(increment.voxel): continue
		return data.increments[data.increments.find(increment) - 1].voxel
	
	return Vector3i(INF, INF, INF)


func get_supported_empty() -> Vector3i:
	for increment in Arrays.reversed(data.increments):
		if not BlockTool.is_air(increment.voxel): continue
		if not BlockTool.is_supported(increment.voxel): continue
		return increment.voxel
	
	return Vector3i(INF, INF, INF)
