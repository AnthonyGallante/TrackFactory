extends Node2D

func _on_start_button_pressed() -> void:
	Loading.load_scene(Global.APPLICATION_PAGE)
