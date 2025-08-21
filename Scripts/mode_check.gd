extends Control

@onready var mode_check_1: GraphFrame = $"../GraphEdit/ModeCheck"
@onready var mode_check_2: GraphFrame = $"../GraphEdit/ModeCheck2"
@onready var mode_check_3: GraphFrame = $"../GraphEdit/ModeCheck3"

# Toggle Buttons vor modes 2 and 3
@onready var mode2_enable: CheckButton = $"../GraphEdit/EntityCustomizationNode/Mode2/ModeHbox/ModeLabel/VBoxContainer/ModeEnable"
@onready var mode3_enable: CheckButton = $"../GraphEdit/EntityCustomizationNode/Mode3/ModeHbox/ModeLabel/VBoxContainer/ModeEnable"

var modes := [mode_check_1, mode_check_2, mode_check_3]
var i: int

func any_nulls(arr: Array) -> bool:
	return arr.any(func(element): return element == null)


func check_params(mode_check: GraphFrame, mode_params: Array):
	mode_check.visible = any_nulls(mode_params)

func _process(delta: float) -> void:
	check_params(mode_check_1, Global.mode1_params)
	
	if mode2_enable.button_pressed:
		check_params(mode_check_2, Global.mode2_params)
	else:
		Global.mode2_params = [null, null, null]
		mode_check_2.visible = false
	
	if mode3_enable.button_pressed:
		check_params(mode_check_3, Global.mode3_params)
	else:
		Global.mode3_params = [null, null, null]
		mode_check_3.visible = false
