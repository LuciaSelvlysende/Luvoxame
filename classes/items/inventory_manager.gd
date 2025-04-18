class_name InventoryManager
extends Node

## An autoload that stores and manages all [Inventory] resources in the game.
##
## [b]See also:[/b] [Inventory] [br][br]
##
## This node is designed to be used as an autoload. However, since autoloads do not support
## [code]@export[/code], certain values need to be configured within the [InventoryManager] script.
## These are marked by the [code]@export[/code] annotation to make it clear what is intended to be
## modified, despite the functionality not being available.

# Dependencies (Required):
# - Inventory (Luvoxame)

# To-do List:
# - Add default_inventory property, new templates will copy properties from default_inventory.
# - Add instance_files property, will store instance ids and their file location.


## Stores [member Inventory.id] as keys and [Inventory] templates
## as values. The uid parameter should point to a [ResourceGroup].
@export var templates: Dictionary[StringName, Inventory] = load_templates("uid://dmbwxtdj2au4d")

## Stores [member Inventory.instance_id] as keys and [Inventory] instances as values.
var instances: Dictionary[int, Inventory] = {} 


## Loads [Inventory] templates specified by the [ResourceGroup] that [param item_group_uid] points to.
func load_templates(template_group_uid) -> Dictionary[StringName, Inventory]:
	var loaded_templates: Dictionary[StringName, Inventory] = {}
	
	var resource_group: ResourceGroup = load(template_group_uid)
	if not resource_group: return {}
	
	for resource in resource_group.load_all():
		if not resource is Inventory: continue
		loaded_templates[resource.id] = resource
	
	return loaded_templates


## Adds an [Inventory] template to [member templates]. Returns [constant ERR_ALREADY_EXISTS] or [constant OK].
func add_template(template: Inventory) -> Error:
	if templates.has(template.id): return ERR_ALREADY_EXISTS
	templates[template.id] = template
	return OK


## Returns the [Inventory] template specified by [param id], or [code]null[/code] if no match is found.
func get_template(id: StringName) -> Inventory:
	return templates.get(id)


## Creates an [Inventory] instance by duplicating the template specified by [param template_id], stores the instance in
## [member instances] along with it's ID, and returns that ID. If the specified template is not found, returns -1.
func create_instance(template_id: StringName) -> int:
	if not get_template(template_id): return -1
	
	var instance: Inventory = get_template(template_id).duplicate(true)
	instance._prepare()
	
	while instances.keys().has(instance.instance_id):
		instance.instance_id = randi()
	
	instances[instance.instance_id] = instance
	return instance.instance_id


## Returns the [Inventory] instance specified by [param id], or [code]null[/code] if no match is found.
func get_instance(id: int) -> Inventory:
	return instances.get(id)
