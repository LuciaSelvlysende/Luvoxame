#class_name Interface
#extends Node2D
#
### Base node for an alternative UI system to [Control] nodes.
###
### Interfaces handle positioning, sizing, and scaling. "Functional" Control nodes, such as buttons,
### labels, or sliders are still used, but they should wrapped as a child node of an Interface. 
### Additionally, Interfaces do not update on their own, and instead rely on an [InterfaceManager] to
### ensure they update in the right order. [br][br]
### 
### [b]Note:[/b] Many units are relative to screen size (or in some cases, the size of other Interfaces).
### This is because different people may have different screen sizes. For example, [code]Vector2(0, 0)[/code]
### is the top left corner of the screen, [code]Vector2(1, 1)[/code] is the bottom right corner, and
### [code]Vector2(0.5, 0.5)[/code] is the center. [br][br]
###
### Positioning is handled by [Anchor]s. First, pick an [member origin] point, relative to the
### Interface's size. Second, pick one or more [member Anchor.termini] points, relative to the corrosponding
### [member Anchor.parents] size. If the parent is not defined, the screen size is used instead. These
### two points will then be "glued" together when the Interface updates. [br][br]
###
### Sizing is handled in a couple ways. By default, the size of the Interface will be based on the combined
### size of all it's children. A [SizeReference] can also be used to base the size of the Interface off
### of one or more [member SizeReference.reference_nodes]. Lastly [member size_override] can be set
### (in pixels), but this is generally not recommended. [br][br]
###
### Scaling is fairly straightforward. [member scaling_mode] controls which components are scaled
### (x, y, both, or neither). Aspect ratio can be controlled using [member keep_aspect_mode].
### A [member min_scale], [member max_scale], and [member scaling_step] may also be defined.
#
#
#enum ChildFilter {
	#INTERFACE,  ## Input for [method filter_children]. Only returns Interface child nodes.
	#CONTROL,  ## Input for [method filter_children]. Only returns Control child nodes.
	#BOTH,  ## Input for [method filter_children]. Returns both Interface and Control child nodes.
#}
#
#enum OriginPresets {
	#USE_PROVIDED,  ## Does not apply any preset. Uses the provided [member origin] instead.
	#CENTER,  ## Centers the origin (sets it to [code]Vector2(0.5, 0.5)[/code]).
	#INNER,  ## Sets the origin to [member anchor]s first terminus. This will position the Interface on the "inside" of whatever it is anchored to.
	#OUTER,  ## Sets the origin to [member anchor]s first terminus, but inverts 0's and 1's. This will position the Interface on the "outside" of whatever it is anchored to.
	#BORDER,  ## Sets the origin to [code]Vector2(0.5, 0.5)[/code] (same as [constant CENTER]). This will position the Interface on the "edge" of whatever it is anchored to.
#}
#
#enum ScalingModes {
	#DISABLED,  ## Scaling is disabled.
	#ENABLED,  ## Scaling is enabled on both x and y axes.
	#X_ONLY,  ## Scaling is enabled on only the x axis.
	#Y_ONLY,  ## Scaling is enabled on only the y axis.
#}
#
#enum KeepAspectModes {
	#DISABLED,  ## Aspect ratio is not maintained.
	#GREATER,  ## The lesser scale component will be set to the greater scale component. For example, a scale of [code]Vector2(0.35, 0.87)[/code] will be set to [code]Vector2(0.87, 0.87)[/code].
	#LESSER,  ## The greater scale component will be set to the lesser scale component. For example, a scale of [code]Vector2(0.35, 0.87)[/code] will be set to [code]Vector2(0.35, 0.35)[/code].
	#X_CONTROLS_Y,  ## Both scale components will be set to [code]scale.x[/code].
	#Y_CONTROLS_X,  ## Both scale components will be set to [code]scale.y[/code].
#}
#
#@export var testing: bool = false
#
#@export_group("Anchoring")
#@export var origin_preset: OriginPresets  ## Various presets that determine the [member origin] of the Interface.
#@export var origin: Vector2 = Vector2.ZERO  ## The origin point used for anchoring. Units are relative to the Interface's size.
#@export var anchor: Anchor = Anchor.new()  ## The [Anchor] used for positioning the Interface. Units are relative to [member Anchor.parent]'s size.
#@export var anchor_offset: Vector2 = Vector2.ZERO ## Offsets the position when updating. Units are relative to screen size. Useful for animation.
#
#@export_group("Sizing")
#@export var size_override: Vector2 = Vector2.ZERO  ## Overrides all other methods of determining size. Units are pixels.
#@export var size_reference: SizeReference  ## Uses a [SizeReference] to base the size of the Interface on other Interfaces.
#@export var margin: Margin = Margin.new()  ## The [Margin] used for the Interface.
#@export var resize_children: bool = false  ## When [code]true[/code], all Control children will have their size set to the Inteface's size.
#
#@export_group("Scaling")
#@export var scaling_mode: ScalingModes  ## Controls which components are scaled.
#@export var keep_aspect_mode: KeepAspectModes  ## Controls how the aspect ratio of the Interface is maintained. See [enum KeepAspectModes].
#@export var min_scale: Vector2 = Vector2.ONE  ## Minimum scale that the Interface will scale to.
#@export var max_scale: Vector2 = Vector2.INF  ## Maximum scale that the Interface will scale to.
#@export var scaling_step: Vector2 = Vector2.ZERO  ## Scale will be snapped to the nearest multiple of [member scaling_step]. Useful for pixel art.
#
#@export_group("Grouping")
#@export var auto_anchor: AutoAnchor  ## Applies an [Anchor] and optional [Margin] to all Interface children. 
#@export var trim_margins: bool = true  ## If [code]true[/code], when determining size based on children, the margins of the children will be ignored.
#@export var trim_hidden: bool = true  ## If [code]true[/code], when determining size based on children, hidden children will be ignored.
#@export var ignore_children: Array[Node] = []  ## Excludes specific nodes from the result of [method filter_children].
#
#@export_group("Updating")
#@export var update_continually: bool = false  ## When [code]true[/code], the Interface will update on each process frame. Useful for animation.
#
#var base_rect: Rect2 = Rect2()  ## The [Rect2] that contains the Interface, excluding the Interface's [member margin].
#var full_rect: Rect2 = Rect2()  ## The [Rect2] that contains the Interface, including the Interface's [member margin].
#var size: Vector2 = Vector2.ZERO  ## The size of the Interface, equivalent to [member full_rect].size.
#
#var manager: InterfaceManager  ## The [InterfaceManager] responsible for handling the Interface. Among other things, controls when the Interface updates.
#
#var _margin_adjusted: bool = false  # Used to prevent applying the margin multiple times.
#
#
#func _process(_delta):
	#if update_continually:
		#update()
#
#
### Filters the result of [method Node.get_children] based on [param filter]. Also excludes any nodes specified by [member ignore_children].
#func filter_children(filter: ChildFilter):
	#var control_children: Array[Control] = []
	#var interface_children: Array[Interface] = []
	#
	#for child in get_children():
		#if ignore_children.has(child): continue
		#if child is Control:
			#control_children.append(child)
		#if child is Interface:
			#interface_children.append(child)
	#
	#match filter:
		#ChildFilter.CONTROL: return control_children
		#ChildFilter.INTERFACE: return interface_children
		#ChildFilter.BOTH: return control_children + interface_children
#
#
### Returns the position and size of the Interface. If [param trim_margin] is [code]true[/code], [member base_rect] will be used instead of [member full_rect].
#func get_rect(trim_margin: bool) -> Rect2:
	#var rect: Rect2 = base_rect if trim_margin else full_rect
	#rect *= Transform2D().scaled(scale)
	#rect.position += position
	#return rect
#
#
### Sets up the Interface so that it is ready to update. Calling [method update] before [method prepare] will crash the game.
#func prepare(assign_manager: InterfaceManager = null) -> void:
	#if assign_manager:
		#manager = assign_manager
	#
	#ResourceInitializer.initialize_batch(self, [anchor, auto_anchor, size_reference, margin])
	#
	#if auto_anchor:
		#auto_anchor.apply(filter_children(ChildFilter.INTERFACE))
	#
	#match origin_preset:
		#OriginPresets.CENTER: origin = Vectors.eq2(0.5)
		#OriginPresets.INNER: origin = anchor.termini[0]
		#OriginPresets.OUTER: origin = Vector2(SC.toggle(anchor.termini[0].x, 0, 1), SC.toggle(anchor.termini[0].y, 0, 1))
		#OriginPresets.BORDER: origin = Vectors.eq2(0.5)
#
#
### Update the size, scale, and position of the Interface. Called by [member manager] when the Interface is added and whenever the screen size is changed.
#func update() -> void:
	#_update_size()
	#_update_scale()
	#_update_position()
	#_margin_adjusted = false
#
#
## Helper funciton for _update_size().
#func _get_combined_children_size():
	#var rect: Rect2
	#var child_rect: Rect2
	#
	#for child in filter_children(ChildFilter.BOTH):
		#if trim_hidden and not child.visible: continue
		#child_rect = child.get_rect(trim_margins) if child is Interface else Rect2(Vector2.ZERO, child.size)
		#
		#if child is Interface and child._margin_adjusted:
			#child_rect.position -= base_rect.position
		#
		#rect = child_rect if child == filter_children(ChildFilter.BOTH).front() else rect.merge(child_rect)
	#
	#return rect.size
#
#
## Helper funciton for update().
#func _update_position() -> void:
	#position = anchor.get_position() - (origin * size * scale) + (anchor_offset * manager.window_size)
#
#
## Helper funciton for update().
#func _update_size() -> void:
	#var reference_size = size_reference.get_size() if size_reference else Vector2.ZERO
	#
	#for i in 2:
		#base_rect.size[i] = size_override[i]
		#if base_rect.size[i]: continue
		#base_rect.size[i] = reference_size[i]
		#if base_rect.size[i]: continue
		#base_rect.size[i] = _get_combined_children_size()[i]
	#
	#margin.apply(self)
	#size = full_rect.size
	#
	#if not resize_children: return
	#for child in filter_children(ChildFilter.CONTROL):
		#child.size = size
#
#
## Helper funciton for update().
#func _update_scale() -> void:
	#var window_scale: Vector2 = manager.window_size / manager.default_window_size
	#var reference_scale: Vector2 = size_reference.get_scale() if size_reference else Vector2.ZERO
	#
	#match keep_aspect_mode:
		#KeepAspectModes.DISABLED: scale = window_scale
		#KeepAspectModes.X_CONTROLS_Y: scale.y = window_scale.x
		#KeepAspectModes.Y_CONTROLS_X: scale.x = window_scale.y
		#KeepAspectModes.GREATER:
			#scale = Vectors.eq2(window_scale.x) if window_scale.x > window_scale.y else Vectors.eq2(window_scale.y)
		#KeepAspectModes.LESSER:
			#scale = Vectors.eq2(window_scale.x) if window_scale.x < window_scale.y else Vectors.eq2(window_scale.y)
	#
	#for i in 2: if reference_scale[i]:
		#scale[i] = reference_scale[i]
	#
	#match scaling_mode:
		#ScalingModes.DISABLED: scale = Vector2.ONE
		#ScalingModes.X_ONLY: scale.y = 1
		#ScalingModes.Y_ONLY: scale.x = 1
	#
	#scale = scale.snapped(scaling_step).clamp(min_scale, max_scale)
