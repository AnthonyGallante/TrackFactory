extends Node2D

@onready var close_pos := Vector2(1450.0, 337.0)
@onready var open_pos := Vector2(950.0, 337.0)
@onready var label: Label = $Panel/Label

enum Status {OPEN, CLOSED}
var status: Status = Status.CLOSED

var new_pos: Vector2
var new_status: Status
var transition_time := 0.1


func _ready() -> void:
	Global.open_node_settings.connect(_on_settings_opened)


func _on_settings_opened(parent_node):
	print(parent_node)
	label.text = str(parent_node)
	toggle_menu()


func _on_close_menu_button_pressed() -> void:
	toggle_menu()


func toggle_menu():
	match status:
		Status.OPEN:
			new_pos = close_pos
			new_status = Status.CLOSED
		Status.CLOSED:
			new_pos = open_pos
			new_status = Status.OPEN
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", new_pos, transition_time)
	status = new_status
	await get_tree().create_timer(1).timeout
	tween.kill()
