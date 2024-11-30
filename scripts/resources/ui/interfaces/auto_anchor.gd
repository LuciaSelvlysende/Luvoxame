class_name AutoAnchor
extends Resource


enum Modes {
	LIST,
}

@export var mode: Modes
@export var direction: Anchor.Presets
@export var weight: Vector2 = Vector2.ONE
@export var margin: Margin
@export var keep_existing: bool = false


func apply(interfaces: Array[Interface]) -> void:
	match mode:
		Modes.LIST:
			list(interfaces)
	
	for interface in interfaces: if margin:
		interface.margin = margin.duplicate()


func list(interfaces: Array[Interface]) -> void:
	for interface in interfaces:
		if interface == interfaces.front(): continue
		interface.origin_preset = Interface.OriginPresets.OUTER
		interface.anchor = Anchor.new()
		interface.anchor.parents = [(interfaces[interfaces.find(interface) - 1])]
		interface.anchor.presets = [direction]
