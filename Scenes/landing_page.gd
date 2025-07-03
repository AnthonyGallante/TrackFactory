extends Node2D

const APPLICATION_PAGE: String = "res://Scenes/application_page.tscn"

func _on_start_button_pressed() -> void:
	Loading.load_scene(APPLICATION_PAGE)
