extends Node2D

@export var bake_interval: float = 0.1

@onready var start_flag: Node2D = $"../MapNode/StartFlag"
@onready var end_flag: Node2D = $"../MapNode/EndFlag"
@onready var line_path: Path2D = $"../MapNode/LinePath2D"
@onready var path_follower: PathFollow2D = $"../MapNode/LinePath2D/PathFollow2D"
@onready var entity: Node2D = $"../MapNode/LinePath2D/PathFollow2D/Entity"
@onready var map: Node2D = $"../MapNode/Map"
@onready var curve := line_path.curve

# Nodes that have been added to the path are recorded in the following:
#   {Point_1: DraggableObject1, Point_2: DraggableObject2, ... }
@onready var path_nodes := {}

var moving := false

var vi_cmd_vector: Array
var vf_cmd_vector: Array
var a_cmd_vector: Array
var dwell_cmd_vector: Array

var dx_vector: Array
var v_vector: Array
var a_vector: Array
var dt_vector: Array

var travel_time: float = 0.0

const PLOT = preload("res://Objects/Plot.tscn")

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
	if len(path_nodes) == 0:
		return
		
	# Draw a line to the position of every node in the path
	for node in path_nodes:
		var index = path_nodes[node] + 1
		curve.set_point_position(index, line_path.to_local(node.true_position.global_position))
		curve.set_point_in(index, Vector2(-node.curvature, 0.0))
		curve.set_point_out(index, Vector2(node.curvature, 0.0))


func reset_path():
	# Clear the path. Add back in the starting and ending nodes
	curve.clear_points()
	for starting_and_ending_nodes in ['Start Point', 'End Point']:
		curve.add_point(Vector2.ZERO)
		
	path_nodes = {}


# Add a new point between existing points
func add_node_at_index(global_pos: Vector2, index: int = -1) -> void:
	var local_pos = line_path.to_local(global_pos)
	reset_entity_progress()
	
	if index == -1:
		# Insert before the last point (keeping end flag at the end)
		index = curve.point_count - 1
	
	curve.add_point(local_pos, Vector2.ZERO, Vector2.ZERO, index)


func remove_node_at_index(index: int = 1) -> void:
	reset_entity_progress()
	curve.remove_point(index)


func _on_bake_points_button_pressed() -> void:
	
	print("\n=== Creating Path ===\n")
	
	# Set the bake_interval 
	curve.bake_interval = 0.05
	
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
	
	var baked_progress := []
	for _b in b:
		baked_progress.append(curve.get_closest_offset(_b) / curve.get_baked_length())
	
	var d := []       # Array of distances between baked points
	var d_tot := 0.0  # The running total distance between baked points
	for i in range(1, len(b)):
		var _d = map.haversine(latlons[i-1].x, latlons[i-1].y, latlons[i].x, latlons[i].y)
		d.append(_d)
	
	for _d in d:
		d_tot += _d
	
	var command_nodes := [start_flag]
	
	 # Get every node in the additional points dictionary
	if len(path_nodes) == 0:
		print("This path has 0 nodes. Entity will travel from START to END.")
		prints("A total distance of", d_tot / 1000, "km")
	else:
		prints("This path has", len(path_nodes), "nodes:")
		
		# START NODE WOULD BE HERE
		
		for p in path_nodes:
			command_nodes.append(p)

		# END NODE WOULD BE HERE

	# Keeps track of the most recent node command for all points in our path
	var command_list := [] 
	var n_points := len(d)
	
	# Used for labelling purposes
	var segment_progress := []
	
	command_list.resize(n_points)
	command_list.fill(0)
	
	for command_node in command_nodes:
		var node_pos: Vector2 = command_node.true_position.global_position
		var node_loc: Vector2 = map.pixel_to_latlon(node_pos.x, node_pos.y)
		var node_progress: float = curve.get_closest_offset(node_pos) / curve.get_baked_length()
		var node_progress_index: float = baked_progress.find(node_progress)
		var node_commands: Dictionary = get_node_commands(command_node)
		
		prints('  - Node:', command_node)
		prints('     - Type:    ', command_node.get_type())
		prints('     - Progress:', node_progress)
		prints('     - Location:', node_loc)
		prints('     - Distance:', d_tot * node_progress)
		prints('     - Index:   ', baked_progress.find(node_progress))
		
		segment_progress.append(node_progress)
		
		for progress_index in range(n_points):
			if progress_index >= node_progress_index:
				command_list[progress_index] = node_commands
	
	#print(command_list)
	segment_progress.append(1.0)
	#print(segment_progress)
	
	var segment_distances = get_segment_deltas(segment_progress, d_tot)
	var segment_midpoint = get_segment_midpoints(segment_progress, curve)
	print(segment_midpoint)
	
	# TODO:  Make these labels nice [OPTIONAL]
	#for i in range(len(segment_midpoint)):
		#print('PRINTING NEW LABEL')
		#var label = Label.new()
		#label.position = segment_midpoint[i]
		#label.z_index = 2000
		#label.text = str(segment_distances[i])
		#add_child(label)
	
	vi_cmd_vector.resize(n_points)
	vf_cmd_vector.resize(n_points)
	a_cmd_vector.resize(n_points)
	dwell_cmd_vector.resize(n_points)
	
	dx_vector = d
	v_vector.resize(n_points)
	a_vector.resize(n_points)
	dt_vector.resize(n_points)
	
	# TODO: CLEAN CLEAN CLEAN
	travel_time = 0.0
	for i in range(n_points):
		var __ = command_list[i]
		vf_cmd_vector[i] = __['Vf']
		vi_cmd_vector[i] = __['Vi']
		
		if __['Vi'] != __['Vf']:
			a_cmd_vector[i] = __['A']
		else:
			a_cmd_vector[i] = 0.0
		
		if i > 0:
			var _v = sqrt((v_vector[i-1] ** 2) + 2 * a_cmd_vector[i] * dx_vector[i])
			
			# Speeding up!
			if _v <= __['Vf'] and a_cmd_vector[i] >= 0.0:
				v_vector[i] = _v
				a_vector[i] = a_cmd_vector[i]
				
			# Slowing down!
			elif _v >= __['Vf'] and a_cmd_vector[i] <= 0.0:
				v_vector[i] = _v
				a_vector[i] = a_cmd_vector[i]
				
			# Not Accelerating!
			elif a_cmd_vector[i] == 0.0:
				v_vector[i] = __['Vf']
				a_vector[i] = 0.0
			else:
				v_vector[i] = vf_cmd_vector[i]
				a_vector[i] = 0.0
			
		# if i == 0:
		else:
			v_vector[i] = vi_cmd_vector[i]
			a_vector[i] = a_cmd_vector[i]
		
		if __['A'] == 0.0:
			v_vector[i] = __['Vf']
		
		dwell_cmd_vector[i] = __['Dwell']
		
		if a_vector[i] != 0:
			dt_vector[i] = solve_for_time(dx_vector[i], v_vector[i], a_vector[i])
		else:
			dt_vector[i] = dx_vector[i] / v_vector[i]
			
		travel_time += dt_vector[i]
		
	#print(v_vector)
	prints("Travel Time:", travel_time / 3600, "hours")
	
	# Handing information over to our plot
	var plot = PLOT.instantiate()
	plot.x_ticks = segment_progress
	plot.x_axis = baked_progress
	plot.y_axis = v_vector
	add_child(plot)


func get_segment_midpoints(pct, _curve):
	var segment_midpoints := []
	for i in range(1, len(pct)):
		var midpoint = (pct[i] + pct[i-1]) / 2
		var offset = _curve.sample_baked(midpoint * _curve.get_baked_length())
		segment_midpoints.append(offset)
	return segment_midpoints


func get_segment_deltas(pct, dist):
	var segment_midpoints := []
	for i in range(1, len(pct)):
		segment_midpoints.append((pct[i] - pct[i-1]) * dist)
	return segment_midpoints


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


# TODO: Check Rigorously 
func solve_for_time(dx: float, v: float, a: float) -> float:
	if a == 0:
		return dx / v
	var root = sqrt((v ** 2) + 2 * a * dx)
	var t1 = (-v + root) / a
	var t2 = (-v - root) / a
	return max(t1, t2)


func get_node_commands(node):
	return {"Vi": node.vi, "Vf": node.vf, 'A': node.a, "Dwell": node.dwell}
	
