extends Control

var default_velocity := 10
var default_hysterisis := 95
var default_reportinterval := 60
var placeholder_text = [default_velocity, default_hysterisis, default_reportinterval]

@onready var mode3_enable: CheckButton = $GraphEdit/EntityCustomizationNode/Mode3/ModeHbox/ModeLabel/VBoxContainer/ModeEnable

@onready var mode1_velocity_value: LineEdit = $GraphEdit/EntityCustomizationNode/Mode1/ModeHbox/VelocityPanel/ModeMinVelocity/HBoxContainer/VelocityValue
@onready var mode1_hysterisis_value: LineEdit = $GraphEdit/EntityCustomizationNode/Mode1/ModeHbox/HysterisisPanel/Hysterisis/HBoxContainer/HysterisisValue
@onready var mode1_report_interval_value: LineEdit = $GraphEdit/EntityCustomizationNode/Mode1/ModeHbox/ReportIntervalPanel/ReportInterval/HBoxContainer/ReportIntervalValue

@onready var mode2_velocity_value: LineEdit = $GraphEdit/EntityCustomizationNode/Mode2/ModeHbox/VelocityPanel/ModeMinVelocity/HBoxContainer/VelocityValue
@onready var mode2_hysterisis_value: LineEdit = $GraphEdit/EntityCustomizationNode/Mode2/ModeHbox/HysterisisPanel/Hysterisis/HBoxContainer/HysterisisValue
@onready var mode2_report_interval_value: LineEdit = $GraphEdit/EntityCustomizationNode/Mode2/ModeHbox/ReportIntervalPanel/ReportInterval/HBoxContainer/ReportIntervalValue

@onready var mode3_velocity_value: LineEdit = $GraphEdit/EntityCustomizationNode/Mode3/ModeHbox/VelocityPanel/ModeMinVelocity/HBoxContainer/VelocityValue
@onready var mode3_hysterisis_value: LineEdit = $GraphEdit/EntityCustomizationNode/Mode3/ModeHbox/HysterisisPanel/Hysterisis/HBoxContainer/HysterisisValue
@onready var mode3_report_interval_value: LineEdit = $GraphEdit/EntityCustomizationNode/Mode3/ModeHbox/ReportIntervalPanel/ReportInterval/HBoxContainer/ReportIntervalValue

func _ready() -> void:
	pass


func enable_fields(fields: Array, state: bool) -> void:
	var i = 0
	
	for field in fields:
		field.editable = state
		
		if state:
			field.placeholder_text = str(placeholder_text[i])
		else:
			field.placeholder_text = ""
		
		i += 1


func _on_mode2_enable_toggled(toggled_on: bool) -> void:
	enable_fields([mode2_velocity_value, mode2_hysterisis_value, mode2_report_interval_value], toggled_on)
	
	# Mode 3 is locked unless Mode 2 is also being used
	mode3_enable.disabled = not toggled_on
	mode3_enable.button_pressed = false


func _on_mode3_enable_toggled(toggled_on: bool) -> void:
	enable_fields([mode3_velocity_value, mode3_hysterisis_value, mode3_report_interval_value], toggled_on)
