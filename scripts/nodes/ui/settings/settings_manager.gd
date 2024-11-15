class_name SettingsManager
extends Node


signal load_settings
signal save_settings
signal discard_settings

@export var settings_libraries: Array[SettingsLibrary] = []

@export_group("Subdivisions")
@export var categories_interface: Interface
@export var groups_interface: Interface
@export var category_scene: PackedScene
@export var group_scene: PackedScene
@export var display_scene: PackedScene

@export_group("Signal Sources")
@export var settings_menu: Menu
@export var save_button: Button
@export var discard_button: Button

var subdivisions: Dictionary = {}
var categories: Array[SettingsCategory]


func _ready():
	settings_menu.opened.connect(_on_load)
	save_button.button_up.connect(_on_save)
	discard_button.button_up.connect(_on_discard)
	
	for settings_library in settings_libraries: for setting in settings_library.settings:
		setting.connect_signals(self)
		SettingsCategory.create(setting, self)
		SettingsGroup.create(setting, self)
		SettingDisplay.create(setting, self)
	
	groups_interface.change_category(categories[0])
	
	if not get_tree().root.is_node_ready(): await get_tree().root.ready
	ResourceInitializer.initialize_batch(get_tree().root, settings_libraries)


func _on_load() -> void:
	load_settings.emit()


func _on_save() -> void:
	save_settings.emit()


func _on_discard() -> void:
	discard_settings.emit()


func get_category(category_id: StringName) -> SettingsCategory:
	for category in categories: if category.id == category_id: return category
	return null
