class_name Force
extends Resource


@export var max_contribution: float = 10
@export var acceleration: float = 1

var contribution: float = 0
var contribution_delta: float = 0


func _init(init_acceleration: float, init_max_contribution: float = 0) -> void:
	acceleration = init_acceleration
	max_contribution = max(init_max_contribution, init_acceleration)


func apply_acceleration() -> void:
	contribution_delta = min(acceleration, max_contribution - contribution)
	contribution += contribution_delta
