class_name SettingsListScript_Lvx
extends ScrollingInterface

## Script for list of settings in the settings menu.
##
## Handles adding new categories and groups to the settings list. Note that this does not include all
## of what's needed to add a category/group to the game, it handles getting them into the settings
## list. The rest of that functionality is found in [FILL THIS IN]. [br][br]


@export var base_root: Interface  ## The root node used for [member ScrollingInterface.scroll_root]. Is duplicated for each category.

var category_roots: Dictionary = {}  ## Keys are [SettingsCategory] ids and values are scroll roots, duplicated from [member base_root].


## Attempts to add a category for the group. Then the group is added to the right category, either an already existing one, or one that was just created.
func add_group(group: SettingsGroup) -> void:
	add_category(group.category)
	category_roots[group.category.id].add_child(group)


## Attempts to add a category. If the category already exists, nothing will happen. 
func add_category(category: SettingsCategory) -> void:
	if category_roots.keys().has(category.id): return
	category_roots[category.id] = base_root.duplicate()
	add_child(category_roots[category.id])
	category.changed_category.connect(change_category)


## Swaps the active category to the specififed [param category]. This is done by simply toggling visibility, and letting [member Interface.trim_hidden] do it's thing.
func change_category(category: SettingsCategory) -> void:
	if not category_roots.keys().has(category.id): return
	
	for category_root in category_roots.values():
		category_root.hide()
	
	scroll_root = category_roots[category.id]
	scroll_root.show()
	reset()
