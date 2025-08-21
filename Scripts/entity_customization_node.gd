extends GraphNode

func _ready() -> void:
	$IconAndThroughput/IconButton.selected = Global.last_selected

func _on_icon_button_item_selected(index: int) -> void:
	
	Global.last_selected = index
	
	match index:
		0:
			Global.selected_icon = Global.GENERIC
		1:
			Global.selected_icon = Global.PEDESTRIAN
		2:
			Global.selected_icon = Global.AUTOMOBILE
		3:
			Global.selected_icon = Global.BOAT
		4:
			Global.selected_icon = Global.TRAIN
		5: 
			Global.selected_icon = Global.PLANE
		_:
			Global.selected_icon = Global.GENERIC

# MODE SETTINGS ====================================================================================

# Velocities
func _on_mode1_velocity_value_submitted(new_text: String) -> void:
	Global.mode1_params[0] = float(new_text)
	
func _on_mode2_velocity_value_submitted(new_text: String) -> void:
	Global.mode2_params[0] = float(new_text)

func _on_mode3_velocity_value_submitted(new_text: String) -> void:
	Global.mode3_params[0] = float(new_text)

# Hysterises
func _on_mode1_hysterisis_value_submitted(new_text: String) -> void:
	Global.mode1_params[1] = float(new_text)
	
func _on_mode2_hysterisis_value_submitted(new_text: String) -> void:
	Global.mode2_params[1] = float(new_text)

func _on_mode3_hysterisis_value_submitted(new_text: String) -> void:
	Global.mode3_params[1] = float(new_text)

# Report Intervals
func _on_mode1_report_interval_value_submitted(new_text: String) -> void:
	Global.mode1_params[2] = float(new_text)

func _on_mode2_report_interval_value_submitted(new_text: String) -> void:
	Global.mode2_params[2] = float(new_text)

func _on_mode3_report_interval_value_submitted(new_text: String) -> void:
	Global.mode3_params[2] = float(new_text)
