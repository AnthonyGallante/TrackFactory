extends MenuBar

@onready var file: PopupMenu = $File
@onready var settings: PopupMenu = $Settings
@onready var help: PopupMenu = $Help
@onready var file_dialog = $FileDialog # Assuming FileDialog is a child node

func _ready() -> void:
	setup_file_menu()
	setup_settings_menu()
	setup_help_menu()

func _process(_delta: float) -> void:
	if file_dialog.visible:
		Global.dialogue_open = true
	else:
		Global.dialogue_open = false

func setup_file_menu():
	file.add_item("Test")
	file.add_item("Exit")


func setup_settings_menu():
	settings.add_item("Choose Output Location")


func setup_help_menu():
	help.add_item("Documentation")


func _on_settings_index_pressed(_index: int) -> void:
	file_dialog.mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.popup()


func _on_file_dialog_dir_selected(dir: String) -> void:
	print("Selected directory: ", dir)
	Global.simulation_output_directory = dir + '/'
