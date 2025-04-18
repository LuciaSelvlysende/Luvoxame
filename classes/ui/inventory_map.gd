class_name InventoryMapper
extends InventoryAssembler


@export var map: Image
@export var margin: Vector4i  ## Up, right, down, left.

var margin_rect: Rect2i
var regions: Array[ItemSlotRegion] = []


func _assemble() -> Array[ItemSlotDisplay]:
	margin_rect = Rect2i(
		Vector2i(margin.w, margin.x),
		Vector2i(margin.w + margin.y, margin.x + margin.z)
		)
	
	read_map()
	build_map()
	return super()


func read_map() -> void:
	var rects: Array[Rect2i] = []
	var grid_sizes: Array[Vector2i] = []
	
	for y in map.get_height(): for x in map.get_width():
		var pixel: Color = map.get_pixel(x, y)
		if not pixel.a: continue
		if pixel == Color.WHITE: continue
		rects.append(Rect2i(Vector2i(x, y), Vector2i.ONE))
		grid_sizes.append(Vector2i(pixel.r8, pixel.g8).max(Vector2i.ONE))
	
	for rect in rects:
		var index: int = rects.find(rect)
		
		while map.get_pixel(rect.position.x + rect.size.x, rect.position.y) != Color.WHITE:
			rect.size.x += 1
			if rect.position.x + rect.size.x >= map.get_width(): break
		
		while map.get_pixel(rect.position.x, rect.position.y + rect.size.y) != Color.WHITE:
			rect.size.y += 1
			if rect.position.y + rect.size.y >= map.get_height(): break
		
		rects[index].size = rect.size + Vector2i.ONE
	
	for index in rects.size():
		var region: ItemSlotRegion = ItemSlotRegion.new()
		region.rect = rects[index]
		region.grid_size = grid_sizes[index]
		regions.append(region)


func build_map() -> void:
	for region in regions:
		var cell_size: Vector2i = region.rect.size / region.grid_size
		
		for y in region.grid_size.y: for x in region.grid_size.x:
			var slot_display: ItemSlotDisplay = ItemSlotDisplay.create(
				region.rect.position + Vector2i(x, y) * cell_size + margin_rect.position,
				cell_size - margin_rect.size,
				)
			
			displays.append(slot_display)


func get_item_slot(instance: Inventory, region: ItemSlotRegion, x: int, y: int) -> ItemSlot:
	var index: int = regions.find(region) + x + y * region.grid_size.y
	return instance.slots[index] if index < instance.size else null


class ItemSlotRegion extends Resource:
	var rect: Rect2i    
	var grid_size: Vector2i
