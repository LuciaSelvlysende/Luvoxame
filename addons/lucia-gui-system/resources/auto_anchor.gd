#class_name AutoAnchor
#extends Resource
#
### A resource used by [Interface]s to automatically create [Anchor]s to arrange their child nodes.
#
#
#enum Modes {
	#LIST,  ## Arranges child nodes in a straight line going in one of eight directions. See [Anchor.Presets].
#}
#
#@export var mode: Modes  ## The mode used to arrange the child nodes.
#@export var direction: Anchor.Presets  ## A direction used for relavent arrangements. See [Anchor.Presets]. Currently includes [constant LIST].
#@export var margin: Margin  ## A [Margin] applied to each child node.
#
#
### Applies the arrangement to [param interfaces]. Called automatically by [method Interfaces.prepare].
#func apply(interfaces: Array[Interface]) -> void:
	#match mode:
		#Modes.LIST:
			#_list(interfaces)
	#
	#for interface in interfaces: if margin:
		#interface.margin = margin.duplicate()
#
#
## Arranges child nodes in a straight line going in one of eight directions. See [Anchor.Presets].
#func _list(interfaces: Array[Interface]) -> void:
	#for interface in interfaces:
		#if interface == interfaces.front(): continue
		#interface.origin_preset = Interface.OriginPresets.OUTER
		#interface.anchor = Anchor.new()
		#interface.anchor.parents = [(interfaces[interfaces.find(interface) - 1])]
		#interface.anchor.presets = [direction]
