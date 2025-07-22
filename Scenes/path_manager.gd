extends Node2D

@export var bake_interval: float = 0.1

@onready var start_flag: Node2D = $"../MapNode/StartFlag"
@onready var end_flag: Node2D = $"../MapNode/EndFlag"
@onready var line_path: Path2D = $"../MapNode/LinePath2D"
@onready var path_follower: PathFollow2D = $"../MapNode/LinePath2D/PathFollow2D"
@onready var entity: Node2D = $"../MapNode/LinePath2D/PathFollow2D/Entity"

@onready var map: Node2D = $"../MapNode/Map"
@onready var curve := line_path.curve

# Additional points are recorded in the following:
#   {Point_1: DraggableObject1, Point_2: DraggableObject2, ... }
@onready var additional_points := {}

var moving := false

func _ready() -> void:
	reset_path()


func _process(_delta: float) -> void:
	
	move_entity(_delta)
	
	line_path.width = 10 / map.camera.zoom.x
	
	# Always update first and last points
	var start_local = line_path.to_local(start_flag.true_position.global_position)
	var end_local = line_path.to_local(end_flag.true_position.global_position)
	
	curve.set_point_position(0, start_local)
	curve.set_point_position(curve.point_count - 1, end_local)
	
	# Check if there are any other points in the path
	if len(additional_points) == 0:
		return
	# Draw a line to the position of every node in the path
	for point in additional_points:
		var index = additional_points[point] + 1
		curve.set_point_position(index, line_path.to_local(point.true_position.global_position))


func reset_path():
	# Clear the path. Add back in the starting and ending nodes
	curve.clear_points()
	for starting_and_ending_nodes in ['Start Point', 'End Point']:
		curve.add_point(Vector2.ZERO)
		
	additional_points = {}


# Add a new point between existing points
func add_point_at_index(global_pos: Vector2, index: int = -1) -> void:
	var local_pos = line_path.to_local(global_pos)
	reset_entity_progress()
	
	if index == -1:
		# Insert before the last point (keeping end flag at the end)
		index = curve.point_count - 1
	
	curve.add_point(local_pos, Vector2.ZERO, Vector2.ZERO, index)


func remove_point_at_index(index: int = 1) -> void:
	reset_entity_progress()
	curve.remove_point(index)


func _on_bake_points_button_pressed() -> void:
	print("\n=== Creating Path ===\n")
	
	# Set the bake_interval 
	curve.bake_interval = 1.0
	
	var b := []       # Array of Baked Points, in original pixels
	var latlons := [] # Array of Baked Points, converted to latlon
	for _p in curve.get_baked_points():
		b.append(_p)
		latlons.append(map.pixel_to_latlon(_p.x, _p.y))
	
	var start = curve.sample_baked(0.0)
	var start_point = map.pixel_to_latlon(start.x, start.y)
	
	var end = curve.sample_baked(curve.get_baked_length())
	var end_point = map.pixel_to_latlon(end.x, end.y)
	
	prints("Start:", start_point)
	prints("End:", end_point)
	
	var baked_progress = []
	for _b in b:
		baked_progress.append(curve.get_closest_offset(_b) / curve.get_baked_length())
	
	var d := []       # Array of distances between baked points
	var d_tot := 0.0  # The running total distance between baked points
	for i in range(1, len(b)):
		var _d = map.haversine(latlons[i-1].x, latlons[i-1].y, latlons[i].x, latlons[i].y)
		d.append(_d)
	
	for _d in d:
		d_tot += _d
	
	 # Get every node in the additional points dictionary
	if len(additional_points) == 0:
		print("This path has 0 waypoints. Entity will travel from START to END.")
		prints("A total distance of", d_tot / 1000, "km")
		return
	else:
		prints("This path has", len(additional_points), "waypoints:")
		
		var i = 1
		for p in additional_points:
			var p_pos = p.global_position
			var p_offset = curve.get_closest_offset(p_pos)
			var p_progress = curve.get_closest_offset(p_pos) / curve.get_baked_length()
			var p_latlon = map.pixel_to_latlon(p_pos.x, p_pos.y)
			# Get the progress ratio for each node in the path
			prints('  - Node:', i)
			prints('     - Offset:', p_offset)
			prints('     - Progress:', p_progress)
			prints('     - Location:', p_latlon)
			prints('     - Distance:', d_tot * p_offset)
			i += 1


func move_entity(delta):
	if path_follower.progress_ratio >= 1.0 - 0.01:
		entity.path_progress = 1.0
		moving = false
		return
	
	if moving:
		path_follower.progress_ratio += 0.3 * delta
		update_entity()


func reset_entity_progress() -> void:
	path_follower.progress_ratio = 0.0
	update_entity()


func update_entity() -> void:
	entity.path_progress = path_follower.progress_ratio


func _on_start_movement_button_pressed() -> void:
	print('Button Pressed.')
	reset_entity_progress()
	moving = true


func calculate_path_vectors():
	pass


func float_range(start: float, end: float, step: float) -> PackedFloat64Array:
	var result = PackedFloat64Array()
	var current = start
	while current <= end:
		result.append(current)
		current += step
	return result
