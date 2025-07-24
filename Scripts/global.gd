extends Node

signal open_node_settings(parent_node)

var most_recently_entered_node
var menu_button_recently_pressed

var is_currently_dragging: bool = false
var is_dragging_available: bool = false
var dragging_start_location: Vector2

# Cursors:
const CURSOR_NONE = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_none.png")
const CURSOR_ALIAS = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_alias.png")
const CURSOR_BUSY = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_busy.png")
const CURSOR_COGS = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_cogs.png")
const CURSOR_DISABLED = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_disabled.png")
const CURSOR_EXCLAMATION = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_exclamation.png")
const CURSOR_HELP = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_help.png")
const CURSOR_MENU = preload("res://Assets/Art/UI/kenney_cursor-pack/PNG/Outline/Default/cursor_menu.png")

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
