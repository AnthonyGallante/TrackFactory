extends MenuBar

@onready var file: PopupMenu = $File
@onready var settings: PopupMenu = $Settings
@onready var help: PopupMenu = $Help

func _ready() -> void:
	setup_file_menu()
	setup_settings_menu()
	setup_help_menu()


func setup_file_menu():
	file.add_item("Test")
	file.add_item("Exit")


func setup_settings_menu():
	settings.add_item("Test")


func setup_help_menu():
	help.add_item("Documentation")
