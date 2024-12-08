class_name Player_Lvx
extends Entity

## Primary script for the player. Handles movement. Will be reworked in Indev 1.5.


enum MovementModes {
	WALK,
	FLY,
}

@export var walk_resource: Movement
@export var fly_resource: Movement
@export var movement_mode = MovementModes.WALK  ## Sets the default movement mode, but is still toggleable in-game.
@export var sensitivity: float = 50.0  ## Mouse sensitivity.
@export var toggle_crouch: bool = false  ## If enabled, will be the default, but is still toggleable in-game.

var crouching: bool = false  ## Whether or not the player is crouching.


func _ready():
	get_tree().root.get_path_to(self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	position = Vector3(0.5, 25, 0.5)


func _on_player_tick():
	TickClock.player_tick_information.transform = transform


func _unhandled_input(event):
	# Look around.
	if event is InputEventMouseMotion:
		rotation.y -=  event.relative.x * sensitivity * 0.00004
		%Camera.rotation.x -=  event.relative.y * sensitivity * 0.00004
		%Camera.rotation.x = clamp(%Camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	# Toggle movement mode.
	if Input.is_action_just_pressed("setting1"):
		movement_mode = SC.toggle(movement_mode, MovementModes.WALK, MovementModes.FLY)
	
	# Toggle toggle crouch.
	if Input.is_action_just_pressed("setting4"):
		toggle_crouch = SC.toggle(toggle_crouch)


func _physics_process(delta):
	# Jump.
	if Input.is_action_pressed("up"):
		walk_resource.jump(self)
	
	if toggle_crouch == false:
		if Input.is_action_just_pressed("crouch"):
			%PlayerCollision.set_height(1.45, 0.1)
			walk_resource.safe_walk = true
			crouching = true
		
		if Input.is_action_just_released("crouch"):
			%PlayerCollision.set_height(1.95, 0.1)
			walk_resource.safe_walk = false
			crouching = false
	
	if toggle_crouch == true:
		if Input.is_action_just_pressed("crouch"):
			if crouching == false:
				%PlayerCollision.set_height(1.45, 0.1)
				walk_resource.safe_walk = true
				crouching = true
			else:
				%PlayerCollision.set_height(1.95, 0.1)
				walk_resource.safe_walk = false
				crouching = false
	
	# Walking/Flying.
	match movement_mode:
		MovementModes.WALK:
			walk_resource.move(self, %PlayerCollision, delta)
		MovementModes.FLY:
			fly_resource.move(self, %PlayerCollision, delta)
