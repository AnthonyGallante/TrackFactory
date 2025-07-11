extends Node2D

const DRAGGABLE_OBJECT = preload("res://Objects/draggable_object.tscn")

func _add_node_button_pressed() -> void:
	var new_node = DRAGGABLE_OBJECT.instantiate()
	new_node.global_position = Vector2(100, 100)
	add_child(new_node)


func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()
