extends Node2D

@export var sprite: Texture2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

var is_draggable_available: bool = false
var is_inside_drop_zone: bool = false

func _ready() -> void:
	sprite_2d.texture = sprite
	area_2d.input_pickable = true
	print('Loaded.')

func _process(_delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	print('Entered!')
	if not Global.is_currently_dragging:
		is_draggable_available = true
		sprite_2d.scale = Vector2(1.05, 1.05)


func _on_area_2d_mouse_exited() -> void:
	print('Exited!')
	if not Global.is_currently_dragging:
		is_draggable_available = false
		sprite_2d.scale = Vector2(1, 1)
