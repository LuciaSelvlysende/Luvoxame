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

@export_group("Subdivision Scenes")
@export var category_scene: PackedScene  ## The scene used to load a [SettingsCategory]. The root node should be a [SettingsCategory].
@export var group_scene: PackedScene  ## The scene used to load a [SettingsGroup]. The root node should be a [SettingsGroup].
@export var display_scene: PackedScene  ## The scene used to load a [SettingDisplay]. The root node should be a [SettingDisplay].

@export_group("Node Connections")
@export var categories_interface: Interface  ## The [Interface] responsible for adding a [SettingsCategory] to the settings menu.
@export var groups_interface: Interface  ## The [Interface] responsible for adding a [SettingsGroup] to the settings menu.

@export_subgroup("Signal Sources")
@export var settings_menu: Menu  ## The [Menu] used to connect [signal Menu.opened] with [method _on_open].
@export var save_button: Button  ## The [Button] used to connect [signal Button.button_up] with [method _on_save].
@export var discard_button: Button  ## The [Button] used to connect [signal Button.button_up] with [method _on_discard].

var categories: Array[SettingsCategory]  ## An array of all [SettingsCategory]s that this SettingsManager created. Primarily used to check if a [SettingsCategory] already exists, in order to prevent a duplicate one from being created.


func _ready():
	settings_menu.opened.connect(_on_open)
	save_button.button_up.connect(_on_save)
	discard_button.button_up.connect(_on_discard)
	
	for settings_library in settings_libraries: for setting in settings_library.settings:
		setting.connect_signals(self)
		SettingsCategory.create(setting, self)
		SettingsGroup.create(setting, self)
		SettingDisplay.create(setting, self)
	
	if not get_tree().root.is_node_ready(): await get_tree().root.ready
	ResourceInitializer.initialize_batch(get_tree().root, settings_libraries)
	groups_interface.change_category(categories[0])


func _on_open() -> void:
	load_settings.emit()


func _on_save() -> void:
	save_settings.emit()


func _on_discard() -> void:
	discard_settings.emit()


## Returns the [SettingsCategory] specified by [param category_id]. Returns [code]null[/code] if there is no category with that id in [member categories]. Primarily used to check if a [SettingsCategory] already exists, in order to prevent a duplicate one from being created.
func get_category(category_id: StringName) -> SettingsCategory:
	for category in categories:
		if category.id == category_id: return category
	
	return null
