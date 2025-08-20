extends Window

@onready var x_axis: Array
@onready var y_axis: Array
@onready var x_ticks: Array

@onready var plot_line: Line2D = $Plot/PlotLine/Line2D

func _ready() -> void:
	plot_line.clear_points()
	plot_line.add_point((Vector2.ZERO))
	
	y_axis.append(0.0)
	#var vmin := 0.0
	#var vmax := 100.0
	#
	#var xmin := 0.0
	#var xmax := 1.0
	
	var x_scale = $Plot/PlotElements/AxisX/StartTick.global_position.distance_to($Plot/PlotElements/AxisX/EndTick.global_position)
	
	if x_axis != null:
		for i in range(len(x_axis)):
			var new_point := Vector2(x_axis[i] * x_scale, -y_axis[i])
			plot_line.add_point(new_point)
	
	# Removes the points that connect back to the x axis
	plot_line.remove_point(0)
	plot_line.remove_point(len(plot_line.points) - 1)


func _on_close_requested() -> void:
	queue_free()
