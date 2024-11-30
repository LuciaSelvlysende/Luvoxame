class_name ExpandingInterface
extends Interface


@export var base: Interface
@export var expanded: Interface
@export var toggle_button: Button


func _ready():
	base = find_child("Base")
	expanded = find_child("Expanded")
	toggle_button = base.find_child("Button").get_child(0)
	
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
	expanded.visible = SC.toggle(expanded.visible)
	manager.update()
