class_name PlayerTickInformation
extends Resource

# Positional information.
@export var transform: Transform3D
@export var raycast: Raycast

# Held item information.
@export var current_block: StringName
@export var current_variant: StringName
@export var current_voxel: int
