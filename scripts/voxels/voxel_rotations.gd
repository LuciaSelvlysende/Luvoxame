class_name VoxelRotations
extends RefCounted


enum Presets {
	USE_PROVIDED,
	HORIZONTAL,
	VERTICAL,
	BOTH,
	AXIAL,
}


static func get_rotations(preset: Presets) -> Array[OrthoBasis]:
	match preset:
		Presets.HORIZONTAL: return [
			OrthoBasis.new(),
			OrthoBasis.new(Vector3i(0, 1, 0)),
			OrthoBasis.new(Vector3i(0, 2, 0)),
			OrthoBasis.new(Vector3i(0, 3, 0)),
		]
		Presets.VERTICAL: return [
			OrthoBasis.new(),
			OrthoBasis.new(Vector3i.ZERO, Vector3i(0, 1, 0)),
		]
		Presets.BOTH: return [
			OrthoBasis.new(),
			OrthoBasis.new(Vector3i(0, 1, 0)),
			OrthoBasis.new(Vector3i(0, 2, 0)),
			OrthoBasis.new(Vector3i(0, 3, 0)),
			OrthoBasis.new(Vector3i.ZERO, Vector3i(0, 1, 0)),
			OrthoBasis.new(Vector3i(0, 1, 0), Vector3i(0, 1, 0)),
			OrthoBasis.new(Vector3i(0, 2, 0), Vector3i(0, 1, 0)),
			OrthoBasis.new(Vector3i(0, 3, 0), Vector3i(0, 1, 0)),
		]
		Presets.AXIAL: return [
			OrthoBasis.new(Vector3i(1, 0, 0)),
			OrthoBasis.new(Vector3i(0, 1, 0)),
			OrthoBasis.new(Vector3i(0, 0, 1)),
		]
	
	return [OrthoBasis.new()]
