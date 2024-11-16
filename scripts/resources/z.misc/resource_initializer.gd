class_name ResourceInitializer
extends Node


static func initialize(root: Node, resource: Resource) -> void:
	if not (resource and root): return
	
	for property in resource.get_property_list():
		if property["name"] == "resource_path": continue
		
		if property["name"].ends_with("_path"):
			initialize_node_path(root, resource, property)
		
		if property["name"].ends_with("_pathes"):
			initialize_node_path_array(root, resource, property)
	
	if resource.has_method("_initialize"): 
		resource._initialize(root)


static func initialize_batch(root: Node, resources: Array) -> void:
	for resource in resources:
		initialize(root, resource)


static func initialize_node_path(root: Node, resource: Resource, path_property: Dictionary) -> void:
	if path_property["type"] != TYPE_NODE_PATH: return

	var node_property_name: StringName = path_property["name"].left(-5)
	var object: Object
	
	if ":" in String(resource.get(path_property["name"])):
		object = root.get_node_and_resource(resource.get(path_property["name"]))[1]
	else:
		object = root.get_node_or_null(resource.get(path_property["name"]))
	
	if not resource.get(node_property_name):
		resource.set(node_property_name, object)


static func initialize_node_path_array(root: Node, resource: Resource, path_array_property: Dictionary) -> void:
	if path_array_property["type"] != TYPE_ARRAY: return
	if resource.get(path_array_property["name"]).get_typed_builtin() != TYPE_NODE_PATH: return
	
	var node_array_property_name: StringName = path_array_property["name"].replace("_pathes", "s")
	var node_array: Array[Node] = []
	
	for node_path in resource.get(path_array_property["name"]):
		node_array.append(root.get_node(node_path) if node_path else null)
	
	if not resource.get(node_array_property_name):
		resource.set(node_array_property_name, node_array)
