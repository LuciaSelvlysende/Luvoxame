class_name BlockAtlas
extends Resource

## A [Resource] that creates a texture atlas from [Block]s.
##
## [b]See also:[/b] [Block], [BlockManager] [br][br]
##
## Textures are sorted into rows by their size. For example, a row of 12 16x16 textures, a row of 19
## 32x32 textures, and a row of 4 128x128 textures. A BlockAtlas is automatically created by
## [BlockManager] and stored in [BlockManager.atlas].

# Dependencies (Required):      Dependencies (Suggested):
# - Block (Luvoxame)            - BlockManager (Luvoxame)

# To-do List: TBD


## The [Image] that stores all [Block]s added to this [BlockAtlas]. Also see [method 
## BlockAtlas.get_texture] and [method BlockAtlas.get_image].
var atlas_image: Image
var atlas_texture: ImageTexture

# Keys are Blocks and values are that Block's textures.
var _block_images: Dictionary[Block, Array] = {}
# Includes exactly one of each texture used by blocks added to the atlas, with no duplicates.
var _unique_images: Array[Image] = []
# Keys are sizes and values are all _unique_images that are that size. 
var _sorted_images: Dictionary[Vector2i, Array] = {}


func _init(blocks: Array[Block] = []) -> void:
	if not blocks: return
	add_blocks(blocks, false)
	build()


## Creates [member BlockAtlas.atlas] using all textures added
## via [method add_block] or [method add_blocks]. 
func build() -> void:
	var size: Vector2i = _get_atlas_size()
	var position: Vector2i = Vector2i.ZERO
	atlas_image = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	
	for image_size in _sorted_images.keys():
		for image in _sorted_images[image_size]:
			# Image.blit_rect() requires images to be of the same format.
			image.decompress()
			image.convert(Image.FORMAT_RGBA8)
			
			atlas_image.blit_rect(image, Rect2i(Vector2i.ZERO, image_size), position)
			_record_rect(image, Rect2i(position, image_size))
			position.x += image_size.x
		
		position.x = 0
		position.y += image_size.y
	
	atlas_texture = ImageTexture.create_from_image(atlas_image)


## Adds [param block]'s textures to the BlockAtlas. If rebuild is [code]true[/code], [member
## BlockAtlas.atlas] will automatically be updated to include the new texture(s). Returns [constant
## ERR_ALREADY_EXISTS] if the block has already been added.
func add_block(block: Block, rebuild: bool = true) -> Error:
	if _block_images.has(block): return ERR_ALREADY_EXISTS
	_block_images[block] = []
	
	for texture in block.textures:
		var image: Image = texture.get_image()
		_block_images[block].append(image)
		
		if _unique_images.has(image): continue
		_unique_images.append(image)
		
		if _sorted_images.has(image.get_size()):
			_sorted_images[image.get_size()].append(image)
		else:
			_sorted_images[image.get_size()] = [image]
	
	if rebuild: build()
	return OK


## Preforms [method add_block] on each [Block] in [blocks]. Returns
## an array of errors produced by each [method add_block] call.
func add_blocks(blocks: Array[Block], rebuild: bool = true) -> Array[Error]:
	var errors: Array[Error] = []
	
	for block in blocks:
		errors.append(add_block(block, false))
	
	if rebuild: build()
	return errors


## Adds the atlas texture to [param block]'s [member Block.material] and adjusts the UV coordinates of 
## [param block]'s [member Block.mesh]. Returns [constant ERR_UNAVAILABLE] if the atlas has not been built yet
## and [constant ERR_UNAUTHORIZED] if the [member Block.use_texture_atlas] is set to [code]false[/code]. 
func apply(block: Block) -> Error:
	if not atlas_image: return ERR_UNAVAILABLE
	if not block.use_texture_atlas: return ERR_UNAUTHORIZED
	
	_adjust_uv_coordinates(block)
	block.material.set_shader_parameter("texture_albedo", atlas_texture)
	return OK


## Preforms [method apply] on all [Block]s in [param blocks]. Returns
## an array of errors produced by each [method add_block] call.
func apply_array(blocks: Array[Block]) -> Array[Error]:
	var errors: Array[Error] = []
	
	for block in blocks:
		errors.append(apply(block))
	
	return errors


# Helper for build().
func _get_atlas_size() -> Vector2i:
	var image_size_sum: Vector2i = Vectors.sum_array(_sorted_images.keys())
	var atlas_size: Vector2i = Vector2i(0, image_size_sum.y if image_size_sum else 0)
	
	for image_size in _sorted_images.keys():
		var width_candidate: int = image_size.x * _sorted_images[image_size].size()
		if width_candidate > atlas_size.x:
			atlas_size.x = width_candidate
	
	return atlas_size


# Helper for build().
func _record_rect(image: Image, rect: Rect2i) -> void:
	for block in _block_images.keys():
		if not _block_images[block].has(image): continue
		var index: int = _block_images[block].find(image)
		block.texture_rects[index] = rect


# Helper for apply().
func _adjust_uv_coordinates(block: Block) -> void:
	var adjusted_mesh = ArrayMesh.new()
	
	for surface in block.mesh.get_surface_count():
		var mesh_arrays: Array = block.mesh.surface_get_arrays(surface)
		var uv_array: PackedVector2Array = mesh_arrays[Mesh.ARRAY_TEX_UV]
		var vertex_sides: Array[Block.Faces] = _get_vertex_sides(block.mesh, surface)
		
		for index in uv_array.size():
			var texture_rect: Rect2 = block.get_texture_rect(vertex_sides[index]) as Rect2
			var position: Vector2 = Vector2(texture_rect.position) / Vector2(atlas_image.get_size())
			var size: Vector2 = uv_array[index] * (Vector2(texture_rect.size) / Vector2(atlas_image.get_size()))
			uv_array[index] = (position + size)
		
		mesh_arrays[Mesh.ARRAY_TEX_UV] = uv_array
		adjusted_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)
	
	block.mesh = adjusted_mesh


# Helper for _adjust_uv_coordinates().
static func _get_vertex_sides(mesh: Mesh, surface: int) -> Array[Block.Faces]:
	var vertex_sides: Array[Block.Faces] = []
	var mesh_tool: MeshDataTool = MeshDataTool.new()
	mesh_tool.create_from_surface(mesh, surface)
	
	for vertex in mesh_tool.get_vertex_count():
		var normal: Vector3 = mesh_tool.get_face_normal(mesh_tool.get_vertex_faces(vertex)[0])
		normal[normal.max_axis_index()] = sign(normal[normal.max_axis_index()])
		normal = normal.floor()
		
		match normal:
			Vector3(1, 0, 0): vertex_sides.append(Block.Faces.POS_X)
			Vector3(-1, 0, 0): vertex_sides.append(Block.Faces.NEG_X)
			Vector3(0, 1, 0): vertex_sides.append(Block.Faces.POS_Y)
			Vector3(0, -1, 0): vertex_sides.append(Block.Faces.NEG_Y)
			Vector3(0, 0, 1): vertex_sides.append(Block.Faces.POS_Z)
			Vector3(0, 0, -1): vertex_sides.append(Block.Faces.NEG_Z)
	
	return vertex_sides
