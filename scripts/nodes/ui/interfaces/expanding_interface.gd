class_name ExpandingInterface
extends Interface


@export var base: Interface
@export var expanded: Interface
@export var toggle_button: Button


func _ready():
	super()
	
	base = get_base()
	expanded = get_expanded()
	toggle_button = get_toggle_button()
	
	toggle_button.button_up.connect(toggle)


func get_base() -> Interface:
	if base: return base
	
	for child in filter_children(ChildFilter.INTERFACE):
		if child.name == "Base": return child
	
	return null


func get_expanded() -> Interface:
	if expanded: return expanded
	
	for child in filter_children(ChildFilter.INTERFACE):
		if child.name == "Expanded": return child
	
	return null


func get_toggle_button() -> Button:
	for child in base.get_children():
		if child.name == "Button" and child.get_child(0) is Button: return child.get_child(0)
	
	return null


func toggle() -> void:
	expanded.visible = Shcut.toggle_variable(expanded.visible)
	InterfaceSynchronizer.update_branch(self)
