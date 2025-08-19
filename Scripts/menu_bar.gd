extends MenuBar

@onready var file: PopupMenu = $File
@onready var settings: PopupMenu = $Settings
@onready var help: PopupMenu = $Help
@onready var file_dialog = $FileDialog # Assuming FileDialog is a child node

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if file_dialog.visible:
		Global.dialogue_open = true
	else:
		Global.dialogue_open = false


func _on_settings_index_pressed(index: int) -> void:
	match index:
		0:
			file_dialog.mode = FileDialog.FILE_MODE_OPEN_DIR
			file_dialog.access = FileDialog.ACCESS_FILESYSTEM
			file_dialog.popup()
		_:
			pass


func _on_file_dialog_dir_selected(dir: String) -> void:
	print("Selected directory: ", dir)
	Global.simulation_output_directory = dir + '/'


func _on_navigation_index_pressed(index: int) -> void:
	match index:
		0:
			Loading.load_scene(Global.HOME_PAGE)
		1:
			Loading.load_scene(Global.APPLICATION_PAGE)
		2:
			Loading.load_scene(Global.CUSTOMIZATION_PAGE)
		_:
			pass
