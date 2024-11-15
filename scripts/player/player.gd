extends CharacterBody3D


enum MOVEMENT_MODES {
	WALK,
	FLY,
}

@export var movement_modes: Array[Movement]  # Different modes for how the player moves.
@export var movement_mode = MOVEMENT_MODES.WALK  # Sets the default movement mode, but is still toggleable in-game.
@export var sensitivity: float = 50.0  # Mouse sensitivity.
@export var toggle_crouch: bool = false  # If enabled, will be the default, but is still toggleable in-game.

var player_tick_information: PlayerTickInformation = PlayerTickInformation.new()
var crouching: bool = false


func _ready():
	get_tree().root.get_path_to(self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	position = Vector3(0.5, 10, 0.5)
	
	player_tick_information.current_block = "dirt"
	player_tick_information.current_variant = "dirt_full"
	player_tick_information.current_voxel = 1


func _on_player_tick():
	player_tick_information.transform = transform
	
	Ticks.player_tick_information = player_tick_information.duplicate()
	
	Ticks.updated_nodes.append(name)


func _unhandled_input(event):
	# Look around.
	if event is InputEventMouseMotion:
		rotation.y -=  event.relative.x * sensitivity * 0.00004
		%Camera.rotation.x -=  event.relative.y * sensitivity * 0.00004
		%Camera.rotation.x = clamp(%Camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	
	# Toggle movement mode.
	if Input.is_action_just_pressed("setting1"):
		movement_mode = Shcut.toggle_variable(movement_mode, MOVEMENT_MODES.WALK, MOVEMENT_MODES.FLY)
	
	
	# Toggle toggle crouch.
	if Input.is_action_just_pressed("setting4"):
		toggle_crouch = Shcut.toggle_variable(toggle_crouch)


func _physics_process(delta):
	# Jump.
	if Input.is_action_pressed("up"):
		movement_modes[movement_mode].jump(self)
	
	if toggle_crouch == false:
		if Input.is_action_just_pressed("crouch"):
			%PlayerCollision.set_height(1.45, 0.1)
			movement_modes[movement_mode].safe_walk = true
			crouching = true
		
		if Input.is_action_just_released("crouch"):
			%PlayerCollision.set_height(1.95, 0.1)
			movement_modes[movement_mode].safe_walk = false
			crouching = false
	
	if toggle_crouch == true:
		if Input.is_action_just_pressed("crouch"):
			if crouching == false:
				%PlayerCollision.set_height(1.45, 0.1)
				movement_modes[movement_mode].safe_walk = true
				crouching = true
			else:
				%PlayerCollision.set_height(1.95, 0.1)
				movement_modes[movement_mode].safe_walk = false
				crouching = false
	
	# Walking/Flying.
	movement_modes[movement_mode].move(self, %PlayerCollision, delta)
