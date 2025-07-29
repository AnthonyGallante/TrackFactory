extends Node2D

@onready var close_pos := Vector2(1450.0, 337.0)
@onready var open_pos := Vector2(950.0, 337.0)
@onready var label: Label = $Panel/Label

var parent

enum Status {OPEN, CLOSED}
var status: Status = Status.CLOSED

var new_pos: Vector2
var new_status: Status
var transition_time := 0.1

# Curvature:
@onready var curve_slider: HSlider = $Panel/VBoxContainer/Curvature/CurveSlider
@onready var curve_value: Label = $Panel/VBoxContainer/Curvature/CurveValue

# Velocity:
@onready var velocity_final_slider: HSlider = $Panel/VBoxContainer/VelocityFinal/VelocitySlider
@onready var velocity_final_value: Label = $Panel/VBoxContainer/VelocityFinal/VelocityValue

@onready var velocity_init_slider: HSlider = $Panel/VBoxContainer/VelocityInitial/VelocitySlider
@onready var velocity_init_value: Label = $Panel/VBoxContainer/VelocityInitial/VelocityValue

# Acceleration:
@onready var acceleration_slider: HSlider = $Panel/VBoxContainer/Acceleration/AccelerationSlider
@onready var acceleration_value: Label = $Panel/VBoxContainer/Acceleration/AccelerationValue

# Dwell:
@onready var dwell_slider: HSlider = $Panel/VBoxContainer/Dwell/DwellSlider
@onready var dwell_value: Label = $Panel/VBoxContainer/Dwell/DwellValue


func _ready() -> void:
	Global.open_node_settings.connect(_on_settings_opened)


func _process(_delta: float) -> void:
	pass

func match_parent_type(parent_node):
	match parent_node.current_type:
		
		0: # START NODE
			velocity_init_slider.editable = true
			velocity_final_slider.editable = true
			acceleration_slider.editable = true
			dwell_slider.editable = true
			return "Start Node"
			
		1: # CONST_V NODE
			velocity_init_slider.editable = true
			velocity_final_slider.editable = false
			acceleration_slider.editable = false
			dwell_slider.editable = false
			return "Constant Velocity Node"
			
		2: # ACCELERATE NODE
			velocity_init_slider.editable = true
			velocity_final_slider.editable = true
			acceleration_slider.editable = true
			dwell_slider.editable = false
			return "Acceleration Node"
			
		3: # DWELL NODE NODE
			velocity_init_slider.editable = true
			velocity_final_slider.editable = true
			acceleration_slider.editable = true
			dwell_slider.editable = true
			return "Dwell Node"
			
		4: # END NODE
			velocity_init_slider.editable = false
			velocity_final_slider.editable = false
			acceleration_slider.editable = false
			dwell_slider.editable = false
			return "End Node"
			
		_: # ELSE/ERROR
			velocity_init_slider.editable = false
			velocity_final_slider.editable = false
			acceleration_slider.editable = false
			dwell_slider.editable = false
			return "ERROR"


func _on_settings_opened(parent_node):
	print(parent_node)
	parent = parent_node
	
	var parent_type = match_parent_type(parent)
	label.text = parent_type
	
	curve_slider.value = parent.curvature
	velocity_init_slider.value = parent.vi
	velocity_final_slider.value = parent.vf
	acceleration_slider.value = parent.a
	dwell_slider.value = parent.dwell
	
	curve_value.text = str(curve_slider.value)
	velocity_init_value.text = str(velocity_init_slider.value)
	velocity_final_value.text = str(velocity_final_slider.value)
	acceleration_value.text = str(acceleration_slider.value)
	dwell_value.text = str(dwell_slider.value)
	
	if status == Status.CLOSED:
		toggle_menu()


func _on_close_menu_button_pressed() -> void:
	toggle_menu()


func toggle_menu():
	match status:
		Status.OPEN:
			new_pos = close_pos
			new_status = Status.CLOSED
		Status.CLOSED:
			new_pos = open_pos
			new_status = Status.OPEN
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", new_pos, transition_time)
	status = new_status
	await get_tree().create_timer(1).timeout
	tween.kill()


func _on_curve_slider_value_changed(value: float) -> void:
	if not parent:
		return 
	parent.curvature = value
	curve_value.text = str(parent.curvature)


func _on_velocity_final_slider_value_changed(value: float) -> void:
	if not parent:
		return 
	parent.vf = value
	velocity_final_value.text = str(parent.vf)


func _on_acceleration_slider_value_changed(value: float) -> void:
	if not parent:
		return 
	parent.a = value
	acceleration_value.text = str(parent.a)


func _on_dwell_slider_value_changed(value: float) -> void:
	if not parent:
		return 
	parent.dwell = value
	dwell_value.text = str(parent.dwell)


func _on_velocity_init_slider_value_changed(value: float) -> void:
	if not parent:
		return 
	parent.vi = value
	velocity_init_value.text = str(parent.vi)
