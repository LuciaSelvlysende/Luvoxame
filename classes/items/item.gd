class_name Item
extends Resource


## A resource that stores information that describes an item.
##
## [b]See also:[/b] [ItemManager], [ItemSlot], [Inventory]. [br][br]

# Dependencies (Required):                  Dependencies (Suggsted):
# - ItemManager (Luvoxame)                  - ItemSlot (Luvoxame)
# - ValueInheritor (Lucia's Utilities)      - Inventory (Luvoxame)

# To-do List:
# - Implement ItemProperties.


## An ID used to access this Item using [method ItemManager.get_item].
@export var id: StringName
## Maximum allowed value for [member ItemSlot.quantity].
@export var stack_size: int
## The block placed when interacting with this item.
@export var block: Block

@export_group("Inheritance")

## The [member Item.id] that propery values will be copied from. Overrides [member base_item].
@export var base_item_id: StringName
## The [Item] that property values will be copied from. See [ValueInheritor] for more
## information. Any @export property changed from the default value will NOT be modified.
@export var base_item: Item
## The [ValueInheritor] used to copy values from [member base_item] and [member ItemManager.base_item].
@export var inheritor: ValueInheritor

@export_group("Visuals")

## Name displayed in-game. Not used by anything behind-the-scenes.
@export var name: String
## A description displayed in-game for the Item.
@export_multiline var description: String
## A texture used to display the Item in-game.
@export var texture: Texture2D


func _prepare() -> void:
	# Inherit property values from base_item.
	if not inheritor:
		inheritor = ValueInheritor.new()
	
	if base_item_id:
		base_item = Items.get_item(base_item_id)
	
	inheritor.default_object = Item.new()
	inheritor.exclude_object = Resource.new()
	inheritor.inherit(self, base_item)
