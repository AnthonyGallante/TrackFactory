extends Node2D

const DRAGGABLE_OBJECT = preload("res://Objects/draggable_object.tscn")
const REFRESH_TIME := 0.3

@onready var map: Node2D = $MapNode/Map

var camera: Camera2D
var refresh_timer := -REFRESH_TIME


func _ready() -> void:
	camera = map.find_child("Camera2D")


func _process(_delta: float) -> void:
	pass


func _add_node_button_pressed() -> void:
	var new_node = DRAGGABLE_OBJECT.instantiate()
	var rng = Vector2(randf_range(-15, 15), randf_range(-15, 15))
	
	new_node.global_position = camera.get_screen_center_position() + rng
	$MapNode.add_child(new_node)


func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()
