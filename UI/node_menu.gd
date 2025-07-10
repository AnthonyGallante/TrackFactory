extends Control

const CIRCLE = preload("res://Assets/Art/Objects/Shapes/circle.png")
const SQUARE = preload("res://Assets/Art/Objects/Shapes/square.png")
const TRIANGLE_UP = preload("res://Assets/Art/Objects/Shapes/triangle_up.png")

var parent: Node
var world: Node
var path_manager: Node


# World
# |- PathManager
# |- Draggable Objects
# |  |- This Script
# |- Path


func _ready() -> void:
	parent = get_parent()
	world = parent.get_parent()
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
	return shape


func _change_shape(shape_resource):
	Global.menu_button_recently_pressed = true
	if _check_parent_node() != shape_resource.resource_path:
		parent.sprite_2d.texture = shape_resource
	else:
		print('Resource is Already Selected.')


func _on_switch_node_constant_velocity_button_down() -> void:
	_change_shape(CIRCLE)


func _on_switch_node_acceleration_button_down() -> void:
	_change_shape(TRIANGLE_UP)


func _on_switch_node_dwell_button_down() -> void:
	_change_shape(SQUARE)


func _on_delete_button_down() -> void:
	path_manager.remove_point_at_index(path_manager.additional_points[parent] + 1)
	parent.queue_free()
	path_manager.additional_points.erase(parent)


func _on_add_node_here_button_down() -> void:
	# Get the index that we will fill
	var most_recently_filled_index = len(path_manager.additional_points)
	path_manager.additional_points[parent] = most_recently_filled_index
	
	path_manager.add_point_at_position(parent.true_position.global_position, most_recently_filled_index + 1)
	print(path_manager.additional_points)
