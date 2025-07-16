extends Control

const CIRCLE = preload("res://Assets/Art/Objects/Shapes/circle.png")
const SQUARE = preload("res://Assets/Art/Objects/Shapes/square.png")
const TRIANGLE_UP = preload("res://Assets/Art/Objects/Shapes/triangle_up.png")
const START_FLAG = preload("res://Assets/Art/Objects/Shapes/start_flag.png")
const STOP_FLAG = preload("res://Assets/Art/Objects/Shapes/stop_flag.png")

var parent: Node
var world: Node
var path_manager: Node


func _ready() -> void:
	parent = get_parent()
	world = parent.get_parent().get_parent()
	path_manager = world.find_child("PathManager")


func _check_parent_node():
	var shape = parent.sprite_2d.texture.resource_path
	
	match shape:
		CIRCLE.resource_path:
			pass
		SQUARE.resource_path:
			pass
		TRIANGLE_UP.resource_path:
			pass
		START_FLAG.resource_path:
			pass
		STOP_FLAG.resource_path:
			pass
	return shape


func _change_shape(shape_resource) -> void:
	Global.menu_button_recently_pressed = true
	if _check_parent_node() != shape_resource.resource_path:
		parent.sprite_2d.texture = shape_resource
	else:
		print('Resource is already selected.')


func _on_switch_node_constant_velocity_button_down() -> void:
	_change_shape(CIRCLE)


func _on_switch_node_acceleration_button_down() -> void:
	_change_shape(TRIANGLE_UP)


func _on_switch_node_dwell_button_down() -> void:
	_change_shape(SQUARE)


func _on_delete_button_down() -> void:
	# Before we delete the point, we check if this point is even in the path.
	if parent in path_manager.additional_points:
		path_manager.remove_point_at_index(path_manager.additional_points[parent] + 1)
		path_manager.additional_points.erase(parent)
	parent.queue_free()


func _on_add_node_here_button_down() -> void:
	# Before we add the point, we check if this point is already in the path.
	if parent not in path_manager.additional_points:
		# Get the index that we will fill
		var most_recently_filled_index = len(path_manager.additional_points)
		path_manager.additional_points[parent] = most_recently_filled_index
		
		path_manager.add_point_at_position(parent.true_position.global_position, most_recently_filled_index + 1)
	else:
		print('Node is already added to the path.')
