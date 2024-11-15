class_name SettingsCategory
extends Interface


signal change_category(active_category: SettingsCategory)

@export var button: Button

var groups: Array[SettingsGroup] = []
var id: StringName


func _ready():
	super()
	button.button_up.connect(_on_category_change)


func _on_category_change() -> void:
	change_category.emit(self)


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


func get_group(group_id: StringName) -> SettingsGroup:
	for group in groups: if group.id == group_id: return group
	return null
