class_name SettingsCategory
extends Interface

## An [Interface] that acts as the highest level of organization for [Setting]s.
##
## Used in the settings menu, a [SettingsCategory] is mostly just a button. When pressed, it will show
## all groups that full under the category and hide all groups that don't.


signal changed_category(active_category: SettingsCategory)  ## Emitted when the active category is changed. The groups in the active category will be shown, and all other groups will be hidden.

@export_group("Node Connections")
@export var button: Button  ## The button that toggles the active category.

var groups: Array[SettingsGroup] = []  ## An array of all [SettingGroup]s that fall under this category.
var id: StringName  ## The id of the category. Primarily used to check if a category already exists, in order to prevent duplicate categories.


func _ready():
	button.button_up.connect(_on_category_change)


func _on_category_change() -> void:
	changed_category.emit(self)


## Creates a fully functional [SettingsCategory]. A [SettingsCategory] made with [method Object.new()] will not work properly.
static func create(setting: Setting, manager: SettingsManager) -> void:
	# Check if the category already exists.
	setting.category = manager.get_category(setting.category_id)
	if setting.category: return
	
	# Set up category.
	setting.category = manager.category_scene.instantiate()
	setting.category.id = setting.category_id
	setting.category.button.text = setting.category_id.capitalize()
	
	# Add category.
	manager.categories.append(setting.category)
	manager.categories_interface.add_child(setting.category)


## Returns the [SettingsGroup] specified by [param group_id]. Returns [code]null[/code] if there is no group with that id that falls under the category.
func get_group(group_id: StringName) -> SettingsGroup:
	for group in groups: if group.id == group_id: return group
	return null
