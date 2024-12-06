class_name SettingsGroup
extends ExpandingInterface

## An [ExpandingInterface] that acts as the second-highest level of organization for [Setting]s.
##
## Used in the settings menu, a [SettingsGroup] is a drop-down menu that contains
## [SettingDisplay]s. SettingsGroups are found in the scrolling part of the settings
## menu, and are only visibile if the [SettingsCategory] they are a part of is the
## active category.


@export_group("Node Connections")
@export var label: Label  ## The [Label] used to display the name of the group.
@export var displays_parent: Interface  ## The parent node for [SettingDisplay]s.

var category: SettingsCategory  ## The [SettingsCategory] that the group falls under.
var id: StringName  ## The id of the group. Primarily used to check if a group already exists, in order to prevent duplicate groups.


## Creates a fully functional [SettingsGroup]. A [SettingsGroup] made with [method Object.new()] will not work properly.
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


## Adds a [SettingDisplay] as a child node of [member displays_parent].
func add_display(display: SettingDisplay) -> void:
	displays_parent.add_child(display)
