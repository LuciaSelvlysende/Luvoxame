class_name PlayerInventoryScript_Lvx
extends Node

## Script for the player's inventory. Currently only handles voxel selection for placement. Will be reworked in Indev 1.2.2.


## Controls what is being cycled through.
enum SCROLL_MODES {
	BLOCK,
	VARIANT,
	VOXEL,
}

var scroll_mode: SCROLL_MODES  ## Controls what is being cycled through.

@onready var player_tick_information = TickClock.player_tick_information  ## Stores information about the player that is updated once per tick.


func _unhandled_input(event):
	# Enable variant selection.
	if event.is_action_pressed("select_variant"):
		scroll_mode = SCROLL_MODES.VARIANT
	if event.is_action_released("select_variant"):
		scroll_mode = SCROLL_MODES.BLOCK
	
	
	# Enable voxel selection.
	if event.is_action_pressed("select_voxel"):
		scroll_mode = SCROLL_MODES.VOXEL
	if event.is_action_released("select_voxel"):
		scroll_mode = SCROLL_MODES.BLOCK
	
	
	# Cycle through either blocks, variants, or voxels, depending on which is selected.
	if not (event.is_action_pressed("cycleUp") or event.is_action_pressed("cycleDown")): return
	var scroll_direction = int(event.is_action_pressed("cycleUp")) - int(event.is_action_pressed("cycleDown"))
	
	match scroll_mode:
		SCROLL_MODES.BLOCK:
			var block_ids = Game.block_library.get_all_block_ids()
			var next_id = block_ids.find(player_tick_information.current_block) + scroll_direction
			
			if next_id == block_ids.size():
				next_id = 0
			
			player_tick_information.current_block = block_ids[next_id]
			
			var block = Game.block_library.get_block(player_tick_information.current_block)
			player_tick_information.current_variant = block.variants[0].id
			
			var variant = Game.block_library.get_variant(player_tick_information.current_variant)
			player_tick_information.current_voxel = variant.voxel_ids[0]
		
		SCROLL_MODES.VARIANT:
			var variant_ids = Game.block_library.get_variant_ids(player_tick_information.current_block)
			var next_id = variant_ids.find(player_tick_information.current_variant) + scroll_direction
			
			if next_id == variant_ids.size():
				next_id = 0
			
			player_tick_information.current_variant = variant_ids[next_id]
			
			var variant = Game.block_library.get_variant(player_tick_information.current_variant)
			player_tick_information.current_voxel = variant.voxel_ids[0]
		
		SCROLL_MODES.VOXEL:
			var voxel_ids = Game.block_library.get_variant(player_tick_information.current_variant).voxel_ids
			var next_id = voxel_ids.find(player_tick_information.current_voxel) + scroll_direction
			
			if next_id > voxel_ids.size() - 1:
				next_id = 0
			
			player_tick_information.current_voxel = voxel_ids[next_id]
