class_name Interface
extends Node2D

enum ChildFilter {
	INTERFACE,  ## Input for [param filter_children]. Only returns [Interface] child nodes.
	CONTROL,  ## Input for [param filter_children]. Only returns [Control] child nodes.
	BOTH,  ## Input for [param filter_children]. Returns both [Interface] and [Control] child nodes.
}

enum OriginPresets {
	USE_PROVIDED,  ## Does not apply any preset. Uses the provided [param origin] instead.
	CENTER,  ## Centers the origin (sets it to [param Vector2(0.5, 0.5)]).
	INNER,  ## Sets the origin to [param anchor]s first terminus. This will position this Interface on the "inside" of whatever it is anchored to.
	OUTER,  ## Sets the origin to [param anchor]s first terminus, but inverts 0's and 1's. This will position this Interface on the "outside" of whatever it is anchored to.
	BORDER,  ## Sets the origin to [param Vector2(0.5, 0.5)] (same as [param CENTER]). This will position this Interface on the "edge" of whatever it is anchored to.
}

enum ScalingModes {
	DISABLED,  ## Scaling is disabled.
	ENABLED,  ## Scaling is enabled on both x and y axes.
	X_ONLY,  ## Scaling is enabled on only the x axis.
	Y_ONLY,  ## Scaling is enabled on only the y axis.
}

enum KeepAspectTypes {
	DISABLED,  ## Aspect ratio is not maintained.
	GREATER,  ## The lesser scale component will be set to the greater scale component. For example, a scale of [param Vector2(0.35, 0.87)] will be set to [param Vector2(0.87, 0.87)].
	LESSER,  ## The greater scale component will be set to the lesser scale component. For example, a scale of [param Vector2(0.35, 0.87)] will be set to [param Vector2(0.35, 0.35)].
	X_CONTROLS_Y,  ## [param scale.y] will be set to [param scale.x].
	Y_CONTROLS_X,  ## [param scale.x] will be set to [param scale.y].
}

@export_group("Anchoring")
@export var origin_preset: OriginPresets  ## Various presets that determine the [origin] of this Interface.
@export var origin: Vector2 = Vector2.ZERO  ## The origin point used for anchoring. Relative to this Interface's size.
@export var anchor: Anchor = Anchor.new()  ## The [Anchor] used for anchoring this Interface.
@export var auto_anchor: AutoAnchor  ## Applies an [Anchor] and optional [Margin] to all Interface children. 
@export var anchor_offset: Vector2  ## Offsets the position when updating. Useful for animation.

@export_group("Sizing")
@export var size_override: Vector2 = Vector2.ZERO  ## Overrides all other methods of determining size. Units are pixels.
@export var size_reference: SizeReference  ## Uses a [SizeReference] to base the [size] of this Interface on other Interfaces.
@export var margin: Margin = Margin.new()  ## The [Margin] used for this Interface.
@export var resize_children: bool = false

@export_group("Scaling")
@export var scaling_mode: ScalingModes  ## Controls which components are scaled.
@export var keep_aspect_mode: ScalingModes
@export var keep_aspect_type: KeepAspectTypes
@export var min_scale: Vector2 = Vector2.ONE
@export var max_scale: Vector2 = Vector2.INF
@export var scaling_step: Vector2 = Vector2.ZERO

@export_group("Grouping")
@export var do_children_adjustment: bool = false
@export var trim_margins: bool = true
@export var trim_hidden: bool = true
@export var ignore_hidden: bool = false
@export var ignore_children: Array[Node] = []

@export_group("Updating")
@export var update_on_window_resize: bool = true
@export var update_continually: bool = false

var base_rect: Rect2 = Rect2()
var full_rect: Rect2 = Rect2()
var size: Vector2 = Vector2.ZERO

var _margin_adjusted: bool = false

@onready var _window_size: Vector2 = get_window().size
@onready var _initial_window_size: Vector2 = get_window().size


func _ready():
	InterfaceSynchronizer.add_interface(self)


func _process(_delta):
	if update_continually:
		update()


func filter_children(filter: ChildFilter):
	var control_children: Array[Control] = []
	var interface_children: Array[Interface] = []
	
	for child in get_children():
		if ignore_hidden and not child.visible: continue
		if ignore_children.has(child): continue
		if child is Control:
			control_children.append(child)
		if child is Interface:
			interface_children.append(child)
	
	match filter:
		ChildFilter.CONTROL: return control_children
		ChildFilter.INTERFACE: return interface_children
		ChildFilter.BOTH: return control_children + interface_children


func get_rect(trim_margin: bool) -> Rect2:
	var rect: Rect2 = base_rect if trim_margin else full_rect
	rect *= Transform2D().scaled(scale)
	rect.position += position #if trim_margin else Vector2.ZERO
	return rect


func prepare() -> void:
	ResourceInitializer.initialize_batch(self, [anchor, auto_anchor, size_reference, margin])
	_apply_presets()


func update() -> void:
	_window_size = get_window().size
	
	_update_size()
	_update_scale()
	_update_position()
	_adjust_children()


func _apply_presets() -> void:
	if auto_anchor:
		auto_anchor.apply(filter_children(ChildFilter.INTERFACE))
	
	match origin_preset:
		OriginPresets.CENTER: origin = Shcut.eq_v2(0.5)
		OriginPresets.INNER: origin = anchor.termini[0]
		OriginPresets.OUTER: origin = Vector2(Shcut.toggle_variable(anchor.termini[0].x, 0, 1), Shcut.toggle_variable(anchor.termini[0].y, 0, 1))
		OriginPresets.BORDER: origin = Shcut.eq_v2(0.5)


func _adjust_children() -> void:
	if not do_children_adjustment: return
	
	var adjust_amount: Vector2 = Vector2.ZERO
	
	for i in 2: for child in filter_children(ChildFilter.INTERFACE):
		if child.global_position[i] >= global_position[i]: continue
		if global_position[i] - child.global_position[i] < adjust_amount[i]: continue
		adjust_amount[i] = global_position[i] - child.global_position[i]
	
	for child in filter_children(ChildFilter.BOTH):
		child.position += adjust_amount


func _get_combined_children_size():
	var rect_a: Rect2
	var rect_b: Rect2
	
	for child in filter_children(ChildFilter.BOTH):
		if trim_hidden and not child.visible: continue
		rect_b = child.get_rect() if child is Control else child.get_rect(trim_margins)
		rect_a = rect_b if child == filter_children(ChildFilter.BOTH).front() else rect_a.merge(rect_b)
	
	return rect_a.size


func _update_position() -> void:
	position = anchor.get_position(self) - (origin * size * scale) + (anchor_offset * _window_size)
	_margin_adjusted = false


func _update_size() -> void:
	var reference_size = size_reference.get_size() if size_reference else Vector2.ZERO
	
	for i in 2:
		base_rect.size[i] = size_override[i]
		if base_rect.size[i]: continue
		base_rect.size[i] = reference_size[i]
		if base_rect.size[i]: continue
		base_rect.size[i] = _get_combined_children_size()[i]
	
	margin.apply(self)
	size = full_rect.size
	
	if not resize_children: return
	for child in filter_children(ChildFilter.CONTROL):
		child.size = size


func _update_scale() -> void:
	var window_scale: Vector2 = _window_size / _initial_window_size
	var reference_scale: Vector2 = size_reference.get_scale() if size_reference else Vector2.ZERO
	
	match keep_aspect_type:
		KeepAspectTypes.DISABLED: scale = window_scale
		KeepAspectTypes.GREATER: scale = Shcut.eq_v2(window_scale.x) if window_scale.x > window_scale.y else Shcut.eq_v2(window_scale.y)
		KeepAspectTypes.LESSER: scale = Shcut.eq_v2(window_scale.x) if window_scale.x < window_scale.y else Shcut.eq_v2(window_scale.y)
		KeepAspectTypes.X_CONTROLS_Y: scale.y = window_scale.x
		KeepAspectTypes.Y_CONTROLS_X: scale.x = window_scale.y
	
	match keep_aspect_mode:
		ScalingModes.DISABLED: scale = window_scale
		ScalingModes.X_ONLY: scale.y = window_scale.y
		ScalingModes.Y_ONLY: scale.x = window_scale.x
	
	for i in 2: if not [0.0, NAN].has(reference_scale[i]):
		scale[i] = reference_scale[i]
	
	match scaling_mode:
		ScalingModes.DISABLED: scale = Vector2.ONE
		ScalingModes.X_ONLY: scale.y = 1
		ScalingModes.Y_ONLY: scale.x = 1
	
	scale = scale.snapped(scaling_step).clamp(min_scale, max_scale)
