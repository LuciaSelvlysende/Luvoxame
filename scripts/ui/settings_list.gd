extends ScrollingInterface


@export var base_root: Interface

var category_roots: Dictionary = {}


func add_group(group: SettingsGroup) -> void:
	add_category(group.category)
	category_roots[group.category.id].add_child(group)


func add_category(category: SettingsCategory) -> void:
	if category_roots.keys().has(category.id): return
	category_roots[category.id] = base_root.duplicate()
	add_child(category_roots[category.id])
	category.change_category.connect(change_category)


func change_category(category: SettingsCategory) -> void:
	if not category_roots.keys().has(category.id): return
	
	for category_root in category_roots.values():
		category_root.hide()
	
	scroll_root = category_roots[category.id]
	scroll_root.show()
	reset()
