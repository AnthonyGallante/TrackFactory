extends Node2D

# State Machines
enum State {IDLE, DRAGGING, MENU_OPEN}
var current_state: State = State.IDLE

enum NodeType {START, CONST_V, ACCELERATE, DWELL, END}
var current_type: NodeType

# Exports
@export var is_start:bool = false
@export var is_end:bool = false

@export var sprite: Texture2D
@export var sprite_scale = 0.18
@export var hover_scale = 1.10
@export var scaling_time = 0.08

var default_dwell: float = 60.0
var default_a: float = 2.0
var default_vi: float = 10.0
var default_vf: float = 10.0

# Required Properties
@export_category("Node Commands")
@export var dwell: float = default_dwell   # Offset added by Dwell properties              : s
@export var a: float = default_a           # Acceleration added by Acceleration properties : m/s^2
@export var vi: float = default_vi         # Velocity of entity entering the node          : m/s
@export var vf: float = default_vf         # The target velocity of the entity             : m/s

# Node references
@onready var node_menu: Control = $NodeMenu
@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var true_position: Node2D = $TruePosition
@onready var type_label: Label = $TruePosition/Label

# Audio
@onready var hover_over: AudioStreamPlayer2D = $Audio/HoverOver
@onready var fail_drag: AudioStreamPlayer2D = $Audio/FailedDrag
@onready var successful_drag: AudioStreamPlayer2D = $Audio/SuccessfulDrag

# State variables
var body_ref
var drag_offset
var start_location
var target_position

var tween: Tween
var menu_tween: Tween

var dragging_start_location: Vector2
var is_hovering: bool = false
var is_inside_drop_zone: bool = false

var attached_path = null
var path_point_index := -1

var map_node
var viewport

# ==============================================================================
# MAIN
# ==============================================================================

func _ready() -> void:
	
	find_map()
	update_type()
	
	sprite_2d.texture = sprite
	sprite_2d.scale = Vector2(1, 1) * sprite_scale
	
	if "flag" in sprite_2d.texture.resource_path:
		sprite_2d.position = Vector2(18.0, -48.0)
		$Area2D.scale = Vector2.ONE * 2
		area_2d.position = Vector2(18.0, -48.0)
		type_label.position -= Vector2(0.0, 10.0)
	
	start_location = global_position
	area_2d.input_pickable = true
	check_disable_buttons()


func _process(_delta: float) -> void:
	
	match current_state:
		State.IDLE:
			_process_idle_state()
		State.DRAGGING:
			_process_dragging_state()
		State.MENU_OPEN:
			_process_menu_open_state()
		
	if is_hovering:
		type_label.text = sprite_2d.texture.resource_path
		type_label.visible = true
		$TruePosition/Coordinates. visible = true
	else:
		type_label.visible = false
		$TruePosition/Coordinates. visible = false
		
	get_node_latlon()
	update_type()
	
	scale = Vector2.ONE / map_node.camera.zoom
	if map_node.camera.zoom < Vector2.ONE * 5.0:
		scale *= 0.75

# ==============================================================================
# STATE PROCESSING
# ==============================================================================

func _process_idle_state() -> void:
	if is_hovering and Input.is_action_just_pressed("left_click") and Global.most_recently_entered_node == self:
		_transition_to_dragging()
	elif is_hovering and Input.is_action_just_pressed("right_click"):
		_transition_to_menu_open()


func _process_dragging_state() -> void:
	# Continue dragging
	global_position = get_global_mouse_position()
	
	# Check for state transitions
	if Input.is_action_just_released("left_click"):
		_end_dragging()
	elif Input.is_action_just_pressed("escape"):
		_cancel_dragging()
	elif Input.is_action_just_pressed("right_click"):
		_cancel_dragging()
		_transition_to_menu_open()


func _process_menu_open_state() -> void:
	if Input.is_action_just_pressed("right_click"):
		_transition_to_idle()
	elif Input.is_action_just_pressed("left_click") and not node_menu.get_global_rect().has_point(get_global_mouse_position()):
		if Global.menu_button_recently_pressed:
			await get_tree().create_timer(0.2).timeout
		_transition_to_idle()
	elif Input.is_action_just_pressed("escape"):
		_transition_to_idle()

# ==============================================================================
# STATE TRANSITIONS
# ==============================================================================

func _transition_to_idle() -> void:
	if current_state == State.MENU_OPEN:
		_close_menu()
	current_state = State.IDLE


func _transition_to_dragging() -> void:
	current_state = State.DRAGGING
	Global.is_currently_dragging = true
	Input.set_custom_mouse_cursor(Global.HAND_CLOSED)
	z_index = 100


func _transition_to_menu_open() -> void:
	if Global.most_recently_entered_node == self:
		current_state = State.MENU_OPEN
		_open_menu()


func _end_dragging() -> void:
	# Play sound
	hover_over.pitch_scale = randf_range(0.9, 1.1)
	successful_drag.play()
	
	# Play animation
	reset_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ONE * sprite_scale * 0.9, 0.05)
	tween.tween_property($Sprite2D, "scale", Vector2.ONE * sprite_scale, scaling_time)
	
	# Reset state
	Global.is_currently_dragging = false
	Input.set_custom_mouse_cursor(Global.CURSOR_NONE)
	z_index = 10
	current_state = State.IDLE


func _cancel_dragging() -> void:
	unsuccessful_drop()
	current_state = State.IDLE

# ==============================================================================
# MENU FUNCTIONS
# ==============================================================================

# TODO: Rewrite using resources
# This has the potential to save a lot of code. However, the insight presented
# itself to me at a stage in the project where, if I attempted to implement,
# would break many dependencies and delay the project.
# We write bad code. We learn new things. We move on. 
func set_type_defaults(_vi: float, _vf: float, _a: float, _dwell: float) -> void:
	vi = _vi
	vf = _vf
	a = _a
	dwell = _dwell


func update_type() -> void:
	match sprite_2d.texture.resource_path:
		"res://Assets/Art/Objects/Shapes/circle.png":
			current_type = NodeType.CONST_V
			type_label.text = "Constant Velocity"
			set_type_defaults(default_vi, default_vf, 0.0, 0.0)
			
		"res://Assets/Art/Objects/Shapes/square.png":
			current_type = NodeType.DWELL
			type_label.text = "Dwell"
			set_type_defaults(default_vi, default_vf, default_a, default_dwell)
			
		"res://Assets/Art/Objects/Shapes/triangle_up.png":
			current_type = NodeType.ACCELERATE
			type_label.text = "Accelerate"
			set_type_defaults(default_vi, default_vf, default_a, 0.0)
			
		"res://Assets/Art/Objects/Shapes/start_flag.png":
			current_type = NodeType.START
			type_label.text = "Start Position"
			set_type_defaults(default_vi, default_vf, default_a, 0.0)
			
		"res://Assets/Art/Objects/Shapes/stop_flag.png":
			current_type = NodeType.END
			type_label.text = "End Position"
			set_type_defaults(0.0, 0.0, 0.0, 0.0)
			
		_:
			current_type = NodeType.CONST_V
			type_label.text = " "
			set_type_defaults(0.0, 0.0, 0.0, 0.0)


func _open_menu() -> void:
	node_menu.visible = true
	node_menu.scale = Vector2(0.01, 0.01)
	
	reset_menu_tween()
	menu_tween.set_ease(Tween.EASE_OUT)
	menu_tween.tween_property(node_menu, "scale", Vector2.ONE * 1.05, 0.04)
	menu_tween.tween_property(node_menu, "scale", Vector2.ONE, 0.04)


func _close_menu() -> void:
	reset_menu_tween()
	menu_tween.set_ease(Tween.EASE_OUT)
	menu_tween.tween_property(node_menu, "scale", Vector2(1.05, 1.05), 0.04)
	menu_tween.tween_property(node_menu, "scale", Vector2(0.01, 0.01), 0.04)
	await menu_tween.finished
	node_menu.visible = false

# ==============================================================================
# HELPER FUNCTIONS
# ==============================================================================


func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()


func reset_menu_tween() -> void:	
	if menu_tween:
		menu_tween.kill()
	menu_tween = create_tween()


func check_successful_drop() -> bool:
	return is_inside_drop_zone


func successful_drop():
	successful_drag.play()
	Global.is_currently_dragging = false
	Input.set_custom_mouse_cursor(Global.CURSOR_NONE)


func unsuccessful_drop():
	fail_drag.play()
	Global.is_currently_dragging = false
	Input.set_custom_mouse_cursor(Global.CURSOR_NONE)
	
	global_position = start_location


func check_disable_buttons():
	
	var buttons = [
			get_node("NodeMenu/Panel/VBoxContainer/Delete"),
			get_node("NodeMenu/Panel/VBoxContainer/SwitchNodeAcceleration"),
			get_node("NodeMenu/Panel/VBoxContainer/SwitchNodeConstantVelocity"),
			get_node("NodeMenu/Panel/VBoxContainer/SwitchNodeDwell"),
			get_node("NodeMenu/Panel/VBoxContainer/AddNodeHere")
		]
	
	if is_start or is_end:
		for button in buttons:
			button.disabled = true


func find_map():
	map_node = get_node("../Map")
	#if map_node:
		#print('Map found:', map_node)
	#else:
		#print('Map not Found.')


func get_node_latlon():
	var latlon = map_node.pixel_to_latlon(true_position.global_position.x, true_position.global_position.y)
	$TruePosition/Coordinates.text = "(%.5f, %.5f)" % [latlon.x, latlon.y]


func get_type():
	return NodeType.keys()[current_type]


# ==============================================================================
# SIGNALS
# ==============================================================================

func _on_area_2d_mouse_entered() -> void:
	if not Global.is_currently_dragging and current_state == State.IDLE:
		# Play Sound
		hover_over.pitch_scale = randf_range(0.93, 1.07)
		hover_over.play()
		
		Global.most_recently_entered_node = self
		is_hovering = true
		Input.set_custom_mouse_cursor(Global.HAND_OPEN)
		
		reset_tween()
		tween.tween_property($Sprite2D, "scale", Vector2.ONE * sprite_scale * hover_scale, scaling_time)


func _on_area_2d_mouse_exited() -> void:
	if not Global.is_currently_dragging and current_state == State.IDLE:
		is_hovering = false
		Input.set_custom_mouse_cursor(Global.CURSOR_NONE)
		
		reset_tween()
		tween.tween_property($Sprite2D, "scale", Vector2.ONE * sprite_scale, scaling_time)
