class_name SettingsManager
extends Node

## A node that manages [Setting]s.
##
## [Setting]s are stored in [member settings_libraries]. The [SettingsManager] uses those [Setting]s
## to direct the creation and addition of the necessary [Interface]s to the settings menu. These include:
## [SettingsCategory]s, [SettingsGroup]s, and [SettingsDisplay]s. The [SettingsManager] is also responsible
## for relaying signals to load, save, and discard settings.


signal load_settings  ## Emitted when the settings menu is opened. Tells [Setting]s to update their [SettingDisplay].
signal save_settings  ## Emitted when the save button is pressed. Tells [Setting]s to save their [Setting.unconfirmed_value].
signal discard_settings  ## Emitted when the discard button is pressed. Tells [Setting]s to discard their [Setting.unconfirmed_value].

@export var settings_libraries: Array[SettingsLibrary] = []  ## An array of [SettingsLibrary]s that hold all the [Setting]s for the settings menu.

@export_group("Displays")
@export var display_parent: Node
@export var display_scene: PackedScene  ## The scene used to load a [SettingDisplay]. The root node should be a [SettingDisplay].

@export_group("Subdivisions")
@export var subdivision_scenes: Array[PackedScene] = []
@export var subdivision_parents: Array[Node] = []

var subdivisions: Array[Array]
var categories: Array[SettingsCategory]  ## An array of all [SettingsCategory]s that this SettingsManager created. Primarily used to check if a [SettingsCategory] already exists, in order to prevent a duplicate one from being created.


func _ready():
	if subdivision_scenes.size() != subdivision_parents.size(): assert(false, "subdivision_scenes and subdivision_parents arrays of %s are not of equivalent size." % self)
	
	# Array.fill() does not work in this case, since fill() does not duplicate the nested arrays.
	subdivisions.resize(subdivision_scenes.size())
	for subdivision in subdivisions:
		subdivision = []
	
	for setting in get_settings():
		setting.connect_signals(self)
		create_subdivision(setting)
		create_display(setting)
	
	if not get_tree().root.is_node_ready(): await get_tree().root.ready
	ResourceInitializer.initialize_batch(get_tree().root, settings_libraries)


func _on_open() -> void:
	load_settings.emit()


func _on_save() -> void:
	save_settings.emit()


func _on_discard() -> void:
	discard_settings.emit()


func create_display(setting: Setting) -> void:
	var display: Node = display_scene.instantiate()
	setting.display = display
	display.setting = setting
	
	if display_parent:
		display_parent.add_display(display)
	else:
		setting.subdivisions.back().add_display(display)


func create_subdivision(setting: Setting) -> void:
	setting.subdivisions.resize(subdivision_scenes.size())
	
	for index in setting.subdivision_ids.size():
		# Ensure that the subdivision does not already exist.
		var subdivision: Node = get_subdivision(index, setting.subdivision_ids[index])
		if subdivision:
			setting.subdivisions[index] = subdivision
			continue
		
		# Create and prepare the subdivision.
		subdivision = subdivision_scenes[index].instantiate()
		subdivision.id = setting.subdivision_ids[index]
		subdivision.parent_subdivisions = get_parent_subdivisions(setting, index)
		
		# Hand the subdivision of to it's parent and store references to it.
		subdivision_parents[index]._add_subdivision(subdivision)
		subdivisions[index].append(subdivision)
		setting.subdivisions[index] = subdivision


func get_settings() -> Array[Setting]:
	var settings: Array[Setting] = []
	
	for settings_library in settings_libraries:
		settings.append_array(settings_library.settings)
	
	return settings


func get_subdivision(index: int, id: StringName) -> Node:
	for subdivision in subdivisions[index]:
		if subdivision.id == id: return subdivision
	
	return null


func get_parent_subdivisions(setting: Setting, index: int) -> Array[Node]:
	var parent_subdivisions: Array[Node] = []
	
	while index > 0:
		index -= 1
		parent_subdivisions.append(setting.subdivisions[index])
	
	return parent_subdivisions
