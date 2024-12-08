class_name SettingsCategory
extends Interface

## An [Interface] that acts as the highest level of organization for [Setting]s.
##
## Used in the settings menu, a [SettingsCategory] is mostly just a button. When pressed, it will show
## all groups that full under the category and hide all groups that don't.


signal changed_category(active_category: SettingsCategory)  ## Emitted when the active category is changed. The groups in the active category will be shown, and all other groups will be hidden.

@export_group("Node Connections")
@export var button: DefaultButton  ## The button that toggles the active category.

var groups: Array[SettingsGroup] = []  ## An array of all [SettingGroup]s that fall under this category.

var id: StringName:  ## The id of the category. Primarily used to check if a category already exists, in order to prevent duplicate categories.
	set(value):
		button.text = value.capitalize()
		id = value

var parent_subdivisions: Array[Node] = []


func _on_category_change() -> void:
	changed_category.emit(self)
