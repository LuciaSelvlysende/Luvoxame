class_name ExpandingInterface
extends Interface

## An [Interface] with a section that is always visible, and a section that is toggled on and off, such as a dropdown menu.
##
## [member base], [member expanded], and [member toggle_button] may all be assigned manually, but they
## will also be detected automatically if the children of the ExpandingInterface follow a standard format:
## [member base] and [member expanded] should both be direct childen of the ExpandingInterface and
## [member toggle_button] should be wrapped in an Interface, which should be a direct child of [member expanded].


@export_group("Node Connections")
@export var base: Interface  ## The section that is [b]not[/b] toggled on and off. This will include the [member toggle_button].
@export var expanded: Interface  ## The section that is toggled on and off (for example, the dropdown part of a dropdown menu).
@export var toggle_button: Button  ## The button that will be connected to [method toggle], which toggles the visibility of the [member expanded] portion.


func _ready():
	# Find node connections that follow the standard format.
	if not base:
		base = find_child("Base", false)
	if not expanded:
		expanded = find_child("Expanded", false)
	if not toggle_button:
		toggle_button = base.find_child("Button", false).get_child(0)
	
	toggle_button.button_up.connect(toggle)


## Toggles the visibility of the [member expanded] portion. [member Interface.trim_hidden] will then take care of the rest.
func toggle() -> void:
	expanded.visible = not expanded.visible
	manager.update()
