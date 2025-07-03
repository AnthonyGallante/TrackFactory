extends Node2D

@onready var start_flag: Node2D = $"../StartFlag"
@onready var end_flag: Node2D = $"../EndFlag"
@onready var line_path_2d: Path2D = $"../LinePath2D"

# Additional points are recorded in the following:
#   {Point_1: DraggableObject1, Point_2: DraggableObject2, ... }
var additional_points := {}


func _ready() -> void:
	reset_path()


func _process(_delta: float) -> void:
	# Always update first and last points
	var start_local = line_path_2d.to_local(start_flag.true_position.global_position)
	var end_local = line_path_2d.to_local(end_flag.true_position.global_position)
	
	line_path_2d.curve.set_point_position(0, start_local)
	line_path_2d.curve.set_point_position(line_path_2d.curve.point_count - 1, end_local)
	
	# Check if there are any other points in the path
	if len(additional_points) > 0:
		for point in additional_points:
			var index = additional_points[point] + 1
			line_path_2d.curve.set_point_position(index, line_path_2d.to_local(point.true_position.global_position))
	# If so, update those points with:
	# For each point, get its index and the node that it is attached to.
	
	# var point_local = line_path_2d.to_local(object.true_position.global_position)
	# line_path_2d.curve.set_point_position(index, point_local)


func reset_path():
	line_path_2d.curve.clear_points()
	additional_points = {}
	
	line_path_2d.curve.add_point(Vector2.ZERO)  # Start point
	line_path_2d.curve.add_point(Vector2.ZERO)  # End point


# Add a new point between existing points
func add_point_at_position(global_pos: Vector2, index: int = -1) -> void:
	var local_pos = line_path_2d.to_local(global_pos)
	
	if index == -1:
		# Insert before the last point (keeping end flag at the end)
		index = line_path_2d.curve.point_count - 1
	
	line_path_2d.curve.add_point(local_pos, Vector2.ZERO, Vector2.ZERO, index)
