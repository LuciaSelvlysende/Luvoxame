class_name ImageComponent
extends ModComponent


@export var resource_id: StringName
@export var file_path: String


func _load_component() -> Error:
	var image: Image = Image.new()
	
	var error: Error = image.load(mod.directory + "/" + file_path)
	if error: return error
	
	return Resources.add(image, resource_id)
