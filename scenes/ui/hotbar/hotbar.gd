extends InventoryMenu


var selected_index: int = 0:
	set(value):
		if selected_index != value:
			selector.reparent(grid.get_child(value), true)
		selected_index = value

@onready var player: CharacterBody3D = %Player

@onready var grid: GridContainer = %Grid
@onready var selector: Panel = %Selector


func _ready() -> void:
	if not player.is_node_ready(): await player.ready
	instance = player.inventory.instance
	super()


func _process(_delta: float) -> void:
	selected_index = player.inventory.selected_index
	super(_delta)
