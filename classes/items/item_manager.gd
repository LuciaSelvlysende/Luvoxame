class_name ItemManager
extends Node

## An autoload that stores and manages all [Item] resources in the game.
##
## [b]See also:[/b] [Item] [br][br]
##
## This node is designed to be used as an autoload. However, since autoloads do not support
## [code]@export[/code], certain values need to be configured within the [ItemManager] script.
## These are marked by the [code]@export[/code] annotation to make it clear what is intended to be
## modified, despite the functionality not being available.

# Dependencies (Required):
# - Item (Luvoxame)

# To-do List:
# - Add default_item property to replace default_stack_size.


## Stores all items in the game. The uid parameter should point to a [ResourceGroup].
@export var items: Dictionary[StringName, Item] = load_items("uid://bvbyhvj5r7ahq")
## The [Item] that all items will copy property values from. See [ValueInheritor] for more information.
## Any @export property on the that is changed from the default value will NOT be modified.
@export var base_item: Item = load("uid://up6a5cd60j2n")


func _ready() -> void:
	# Assign default values.
	for item in items.values():
		item._prepare()
		item.inheritor.inherit(item, base_item)


## Loads [Item]s specified by the [ResourceGroup] that [param item_group_uid] points to.
func load_items(item_group_uid) -> Dictionary[StringName, Item]:
	var loaded_items: Dictionary[StringName, Item] = {}
	
	var resource_group: ResourceGroup = load(item_group_uid)
	if not resource_group: return {}
	
	for resource in resource_group.load_all():
		if not resource is Item: continue
		loaded_items[resource.id] = resource
	
	return loaded_items


## Adds an [Item] to the game. Returns [constant OK] if successful, otherwise returns an [enum Error].
func add_item(item: Item) -> Error:
	if not item: return ERR_INVALID_PARAMETER
	if items.has(item.id): return ERR_ALREADY_EXISTS
	items[item.id] = item
	return OK


## Returns the [Item] specified by [param id].
func get_item(id: StringName) -> Item:
	return items.get(id)


## Takes a [Variant] parameter and returns either [code]null[/code] or [Item].
## Items are returned unchanged. [String]s and [StringName]s are tried as IDs. 
func ensure_item(param) -> Item:
	if not param: return null
	if param is Item: return param
	if not [TYPE_STRING, TYPE_STRING_NAME].has(typeof(param)): return null
	return get_item(param)
