extends CollisionShape3D

# Used if the player tries to uncrouch, but can't. These store the needed information to uncrouch when possible.
var stuck: bool = false
var desired_height: float = 0
var desired_duration: float = 0


func _physics_process(_delta):
	# Prevent the player's collision shape from rotating with the player.
	global_rotation = Vector3.ZERO


func _on_player_tick():
	if stuck and _has_overhead_space(desired_height):
		stuck = false
		set_height(desired_height, desired_duration)
	
	Ticks.updated_nodes.append(name)


# Changes the height of the player's collision, alongside intelligently changing other player elements to match.
func set_height(height, transition_duration) -> void:
	if not _has_overhead_space(height):
		stuck = true
		desired_height = height
		desired_duration = transition_duration
		return
	
	var inital_height: float = shape.size.y
	var offset: float = (height - inital_height) * 0.5
	
	# Reset the animation.
	%Animations.stop(true)
	var animation = %Animations.get_animation("crouch")
	animation.length = transition_duration
	animation.clear()
	
	# Add tracks to the animation.
	var collision_height = animation.add_track(Animation.TYPE_VALUE)
	var collision_position = animation.add_track(Animation.TYPE_VALUE)
	var camera_position = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(collision_height, "PlayerCollision:shape:size:y")
	animation.track_set_path(collision_position, "PlayerCollision:position:y")
	animation.track_set_path(camera_position, "Camera:position:y")
	
	# Add keys to change the collision height.
	animation.track_insert_key(collision_height, 0, inital_height)
	animation.track_insert_key(collision_height, transition_duration, height)
	
	# Add keys to change the collision position, so it appears that height is only being removed from the top.
	animation.track_insert_key(collision_position, 0, position.y)
	animation.track_insert_key(collision_position, transition_duration, position.y + offset)
	
	# Add keys to change the camera position.
	animation.track_insert_key(camera_position, 0, %Camera.position.y)
	animation.track_insert_key(camera_position, transition_duration, %Camera.position.y + offset)
	
	%Animations.play("crouch")


func _has_overhead_space(height: float) -> bool:
	var collision_parameters: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	
	collision_parameters.exclude = [RID($"..")]
	collision_parameters.shape = shape.duplicate()
	collision_parameters.shape.size.y = height
	collision_parameters.transform = Transform3D(Basis(), global_position)
	collision_parameters.transform.origin.y += (height - shape.size.y) * 0.5
	
	if Game.physics_space.intersect_shape(collision_parameters, 1).is_empty():
		return true
	else:
		return false
