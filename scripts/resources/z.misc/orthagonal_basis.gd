class_name OrthagonalBasis
extends Resource

const XYZ: int = 0
const XZY: int = 1
const YXZ: int = 2
const YZX: int = 3
const ZXY: int = 4
const ZYX: int = 5

const PPP: int = 0
const PNP: int = 1
const PPN: int = 2
const PNN: int = 3
const NPP: int = 4
const NNP: int = 5
const NPN: int = 6
const NNN: int = 7

const component_permutations: Array[Basis] = [
	Basis(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1)),	# xyz
	Basis(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 1, 0)),	# xzy
	Basis(Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1)),	# yxz
	Basis(Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(1, 0, 0)),	# yzx
	Basis(Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 1, 0)),	# zxy
	Basis(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(1, 0, 0)),	# zyx
]

const sign_permutations: Array[Vector3] = [
	Vector3(1, 1, 1),		# +++
	Vector3(1, -1, 1),		# +-+
	Vector3(1, 1, -1),		# ++-
	Vector3(1, -1, -1),		# +--
	Vector3(-1, 1, 1),		# -++
	Vector3(-1, -1, 1),		# --+
	Vector3(-1, 1, -1),		# -+-
	Vector3(-1, -1, -1),	# ---
]


static func get_basis(component_index: int, sign_index: int) -> Basis:
	var basis: Basis = component_permutations[component_index]
	
	for i in 3:
		basis[i] *= sign_permutations[sign_index][i]

	return basis
