extends Panel


func close() -> void:
	if visible:
		toggle()


func open() -> void:
	if not visible:
		toggle()


func toggle() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "self_modulate", Color.TRANSPARENT if visible else Color.WHITE, 0.2)
	if visible: await tween.finished
	visible = not visible
