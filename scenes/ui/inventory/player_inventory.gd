extends InventoryMenu


@onready var player: CharacterBody3D = %Player


func _ready() -> void:
	if not player.is_node_ready(): await player.ready
	instance = player.inventory.instance
	super()
