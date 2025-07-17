extends Node2D

@export var n_baked_points := 10

@onready var start_flag: Node2D = $"../MapNode/StartFlag"
@onready var end_flag: Node2D = $"../MapNode/EndFlag"
@onready var line_path_2d: Path2D = $"../MapNode/LinePath2D"
@onready var path_follow_2d: PathFollow2D = $"../MapNode/LinePath2D/PathFollow2D"
@onready var map: Node2D = $"../MapNode/Map"
@onready var curve := line_path_2d.curve

# Additional points are recorded in the following:
#   {Point_1: DraggableObject1, Point_2: DraggableObject2, ... }
@onready var additional_points := {}

func _ready() -> void:
	reset_path()

func _process(_delta: float) -> void:
	
	line_path_2d.width = 10 / map.camera.zoom.x
	
	# Always update first and last points
	var start_local = line_path_2d.to_local(start_flag.true_position.global_position)
	var end_local = line_path_2d.to_local(end_flag.true_position.global_position)
	
	curve.set_point_position(0, start_local)
	curve.set_point_position(curve.point_count - 1, end_local)
	
	# Check if there are any other points in the path
	if len(additional_points) == 0:
		return
	# Draw a line to the position of every node in the path
	for point in additional_points:
		var index = additional_points[point] + 1
		curve.set_point_position(index, line_path_2d.to_local(point.true_position.global_position))


func reset_path():
	# Clear the path. Add back in the starting and ending nodes
	curve.clear_points()
	for starting_and_ending_nodes in ['Start Point', 'End Point']:
		curve.add_point(Vector2.ZERO)
		
	additional_points = {}


# Add a new point between existing points
func add_point_at_index(global_pos: Vector2, index: int = -1) -> void:
	var local_pos = line_path_2d.to_local(global_pos)
	
	if index == -1:
		# Insert before the last point (keeping end flag at the end)
		index = curve.point_count - 1
	
	curve.add_point(local_pos, Vector2.ZERO, Vector2.ZERO, index)


func remove_point_at_index(index: int = 1) -> void:
	curve.remove_point(index)


func _on_bake_points_button_pressed() -> void:
	# TODO: FIND SOURCE
	var mystery_offset := Vector2(4.666666, -2.033333)
	
	var b := []       # Array of Baked Points
	var d := []       # Array of distances between baked points
	var d_tot := 0.0  # The running total distance between baked points
	
	# Set the bake_interval 
	curve.bake_interval = curve.get_baked_length() / n_baked_points
	
	for _p in curve.get_baked_points():
		b.append(map.pixel_to_latlon(_p.x, _p.y) + mystery_offset)
	
	for i in range(1, len(b)):
		var _d = map.haversine(b[i-1].x, b[i-1].y, b[i].x, b[i].y)
		d.append(_d)
		d_tot += _d
	
	# Get every node in the additional points dictionary
	if len(additional_points) == 0:
		return
	else:
		for p in additional_points:
			pass
			
	# Get the nearest baked point to each node
	# Get the progress ratio for each node in the path
	# Get the distance between each node
	
