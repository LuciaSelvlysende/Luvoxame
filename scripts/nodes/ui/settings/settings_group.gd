class_name SettingsGroup
extends ExpandingInterface


@export var label: Label
@export var setting_displays_parent: Interface

var category: SettingsCategory
var id: StringName


static func create(setting: Setting, manager: SettingsManager) -> void:
	# Check if the category already exists.
	setting.group = setting.category.get_group(setting.group_id)
	if setting.group: return
	
	# Set up group.
	setting.group = manager.group_scene.instantiate()
	setting.group.id = setting.group_id
	setting.group.label.text = setting.group_id.capitalize()
	setting.group.category = setting.category
	
	# Add group.
	setting.category.groups.append(setting.group)
	manager.groups_interface.add_group(setting.group)
