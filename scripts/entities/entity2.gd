class_name Entity2
extends CharacterBody3D

# Features Implemented:
# - Acceleration.
# - Max speed / force.
# - Max total speed.
# - Deceleration.
# - Collision force (maybe).

# To-do:
# - Test collision force.
# - Vectors.


@export var max_velocity: float = 50
@export var deceleration: float = 1

var forces: Array[Force] = []


func _physics_process(_delta: float) -> void:
	var new_velocity: float = 0
	
	# Apply acceleration.
	for force in forces:
		force.apply_acceleration()
	
	# Apply forces.
	for force in forces:
		cancel_force(force)
		new_velocity += force.contribution
	
	# Apply deceleration.
	var total_deceleration: float = deceleration# * bool(new_velocity) * not bool(new_velocity - velocity)
	
	for force in forces:
		if not force.contribution: continue
		if force.contribution_delta: continue
		force.contribution -= total_deceleration * force.contribution / velocity.x
	
	# Clamp velocity.
	var clamped_velocity: float = clamp(new_velocity, -max_velocity, max_velocity)
	cancel_force(Force.new(clamped_velocity - new_velocity))
	
	# Move and apply collision force.
	velocity.x = new_velocity
	move_and_slide()
	cancel_force(Force.new(velocity.x - new_velocity))


func add_force(force: Force) -> void:
	forces.append(force)


func cancel_force(opposing_force: Force) -> void:
	if sign(opposing_force.contribution) == sign(velocity): return
	
	var canceled_force: float = 0
	
	for force in forces:
		if force == opposing_force: continue
		
		var partial_contribution: float = opposing_force.contribution * (force.contribution / velocity.x)
		force.contribution += partial_contribution
		force.contribution_delta += partial_contribution
		canceled_force += partial_contribution
	
	opposing_force.contriubtion -= canceled_force
