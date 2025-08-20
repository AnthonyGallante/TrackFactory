extends Node

signal open_node_settings(parent_node)

var most_recently_entered_node
var menu_button_recently_pressed

var is_currently_dragging: bool = false
var is_dragging_available: bool = false
var dragging_start_location: Vector2
var dialogue_open: bool = false

var simulation_output_directory = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS) + '/'

# SCENE TRANSITIONS ================================================================================
const HOME_PAGE: String = "res://Scenes/landing_page.tscn"
const APPLICATION_PAGE: String = "res://Scenes/application_page.tscn"
const CUSTOMIZATION_PAGE: String = "res://Scenes/entity_custimization.tscn"


# CURSORS: =========================================================================================
# Arrow cursors
const CURSOR_NONE = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_none.png")
const CURSOR_ALIAS = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_alias.png")
const CURSOR_BUSY = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_busy.png")
const CURSOR_COGS = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_cogs.png")
const CURSOR_DISABLED = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_disabled.png")
const CURSOR_EXCLAMATION = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_exclamation.png")
const CURSOR_HELP = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_help.png")
const CURSOR_MENU = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_menu.png")

# Hand cursors
const HAND_OPEN = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/hand_open.png")
const HAND_CLOSED = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/hand_closed.png")
const HAND_POINT = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/hand_point.png")
const HAND_POINT_E = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/hand_point_e.png")
const HAND_POINT_N = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/hand_point_n.png")


func _process(_delta: float) -> void:
	if menu_button_recently_pressed:
		await get_tree().create_timer(0.5).timeout
		menu_button_recently_pressed = false
	pass

# **************************************************************************************************
# ============================================ SETTINGS ============================================ 
# **************************************************************************************************

# In the order in which they are shown in the entity_customization scene.
var n_simulations := 500

# ENTITY ICONS: ====================================================================================
const GENERIC = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border01.png")
const PEDESTRIAN = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border04.png")
const BOAT = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border14.png")
const PLANE = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border15.png")
const TRAIN = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border16.png")
const AUTOMOBILE = preload("res://Assets/Art/Objects/kenney_boardgame-pack/PNG/Pieces (Green)/pieceGreen_border13.png")

var selected_icon := GENERIC
var last_selected := 0

var throughput := 92.0

# Distributions
enum Distribution {NORMAL, UNIFORM}

var latitude_distribution: Distribution = Distribution.NORMAL
var longitude_distribution: Distribution = Distribution.NORMAL
var velocity_distribution: Distribution = Distribution.NORMAL

var latitude_params := [0.0, 1.0]
var longitude_params := [0.0, 1.0]
var velocity_params := [0.0, 1.0]
