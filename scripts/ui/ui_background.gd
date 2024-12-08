class_name UIBackground_Lvx
extends Panel

## The default background used while a [Menu] is opened.
##
## Whether or not a menu uses this background is controlled by [member Menu.use_background].


## Shortcut function to hide the background.
func close() -> void:
	if visible:
		toggle()


## Shortcut function to show the background.
func open() -> void:
	if not visible:
		toggle()


## Toggles the background's visibility, using an animation.
func toggle() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", Color.TRANSPARENT if visible else Color.WHITE, 0.2)
	if visible: await tween.finished
	visible = not visible
