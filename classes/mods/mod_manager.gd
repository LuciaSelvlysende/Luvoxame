class_name ModManager
extends Node


signal loaded

const MODS_PATH: String = "user://mods"
const MOD_FILE: String = "mod.tres"

var mods: Dictionary = {}


func _ready() -> void:
	var dir: DirAccess = DirAccess.open("user://")
	if not dir.dir_exists("mods"):
		dir.make_dir("mods")
	
	var error: Error = OK
	
	for callable in [scan_mods, sort_mods, apply_mods]:
		error = callable.call()
		if error: push_error("Error while loading mods (step = %s): %s." % [
			callable.get_method(),
			error_string(error)
		])
	
	loaded.emit()


func scan_mods(path: StringName = MODS_PATH, mod: Mod = null) -> Error:
	var directory: DirAccess = DirAccess.open(path)
	if not directory: return DirAccess.get_open_error()
	
	if not mod and directory.file_exists(MOD_FILE):
		var resource: Resource = ResourceLoader.load(directory.get_current_dir() + "/" + MOD_FILE)
		mod = resource if resource is Mod else null
		mod.directory = path
		mods[mod] = []
	
	for subdirectory in directory.get_directories():
		scan_mods(path + "/" + subdirectory, mod)
	
	if not mod: return OK
	
	for file in directory.get_files():
		if not file.ends_with(".tres"): continue
		var resource: Resource = ResourceLoader.load(directory.get_current_dir() + "/" + file)
		if not resource is ModComponent: continue
		resource.mod = mod
		mods[mod].append(resource)
	
	return OK


func sort_mods() -> Error:
	var sorted_mod_ids: Array[StringName] = []
	var sorted_mods: Dictionary = {}
	var added_mods: int = 0
	
	while true:
		for mod in mods:
			if sorted_mod_ids.has(mod.id): continue
			if not SC.has_array(sorted_mod_ids, mod.dependencies): continue
			sorted_mod_ids.append(mod.id)
			added_mods += 1
		
		if added_mods == 0: break
		added_mods = 0
	
	if sorted_mod_ids.size() != mods.size(): return ERR_TIMEOUT
	
	for mod_id in sorted_mod_ids: for mod in mods:
		if not mod_id == mod.id: continue
		sorted_mods[mod] = mods[mod]
	
	mods = sorted_mods
	return OK


func apply_mods() -> Error:
	for mod in mods: for component in mods[mod]:
		var error: Error = component._load_component()
		if error: return error
	
	return OK
