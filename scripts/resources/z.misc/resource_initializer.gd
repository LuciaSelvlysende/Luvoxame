class_name ResourceInitializer
extends Node


## Helper resource designed to make it easier to work with [Node] properties in a [Resource].

## Initializing a [Resource] does two things. First, it looks for [NodePath] and [Node] properties
## (or [NodePath]/[Node] [Array]s) with almost matching names. The difference should be "_path" at the end
## of the [NodePath] property, or "_paths" at the end of the [NodePath] [Array] property.
## Secondly, if the resource has a _initialize() method, it will be called.


## Initializes the provided resource.
static func initialize(root: Node, resource: Resource) -> void:
	if not (resource and root): return
	
	for property in resource.get_property_list():
		# Property of all Resources, should be skipped.
		if property["name"] == "resource_path": continue
		
		if property["name"].ends_with("_path"):
			_initialize_node_path(root, resource, property)
		
		if property["name"].ends_with("_pathes"):
			_initialize_node_path_array(root, resource, property)
	
	if resource.has_method("_initialize"): 
		resource._initialize(root)


## Initializes an array of resources.
static func initialize_batch(root: Node, resources: Array) -> void:
	for resource in resources:
		initialize(root, resource)


# Matches a NodePath property to a Node property of the same name minus "_path" at the end.
# Also works for NodePaths that point to a resource property.
static func _initialize_node_path(root: Node, resource: Resource, path_property: Dictionary) -> void:
	if path_property["type"] != TYPE_NODE_PATH: return
	
	var node_property_name: StringName = path_property["name"].left(-5)
	var object: Object
	
	# If the target property already has a value, it will not be overwritten.
	if resource.get(node_property_name): return
	
	# If a NodePath points to a Resource property, it will contain a ":".
	if ":" in String(resource.get(path_property["name"])):
		object = root.get_node_and_resource(resource.get(path_property["name"]))[1]
	else:
		object = root.get_node_or_null(resource.get(path_property["name"]))
	
	resource.set(node_property_name, object)


# Matches an Array of NodePaths to an Array of Nodes of the same name minus "_pathes" at the end.
# Does not currently support NodePath Arrays that point to Resource Arrays.
static func _initialize_node_path_array(root: Node, resource: Resource, path_array_property: Dictionary) -> void:
	if path_array_property["type"] != TYPE_ARRAY: return
	if resource.get(path_array_property["name"]).get_typed_builtin() != TYPE_NODE_PATH: return
	var node_array_property_name: StringName = path_array_property["name"].replace("_pathes", "s")
	var node_array: Array[Node] = []
	
	# If the target property already has a value, it will not be overwritten.
	if resource.get(node_array_property_name): return
	
	for node_path in resource.get(path_array_property["name"]):
		node_array.append(root.get_node(node_path) if node_path else null)
	
	resource.set(node_array_property_name, node_array)
