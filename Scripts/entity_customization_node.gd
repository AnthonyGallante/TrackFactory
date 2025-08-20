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
