extends Node2D

const MAP_WIDTH: float = 10800.0
const MAP_HEIGHT: float = 5400.0

var mouse_loc: Vector2
var coordinate: Vector2

@onready var camera: Camera2D = $Camera2D
const SCROLL_PACE: float = 0.1
const SCROLL_SPEED: float = 0.07
var tween: Tween


func _process(_delta: float) -> void:
	
	mouse_loc = get_global_mouse_position()
	coordinate = pixel_to_latlon(mouse_loc.x, mouse_loc.y)
	
	control_scroll()


func latlon_to_pixel(latitude: float, longitude: float) -> Vector2:
	var y = -latitude * (MAP_HEIGHT / 180.0) 
	var x = longitude * (MAP_WIDTH / 360.0)
	return Vector2(x, y)


func pixel_to_latlon(x: float, y: float) -> Vector2:
	var latitude = -y / (MAP_HEIGHT / 180.0) 
	var longitude = x / (MAP_WIDTH / 360.0)
	
	if abs(longitude) > 180.0:
		longitude = -fmod(x / (MAP_WIDTH / 360.0), 180.0)
	
	return Vector2(latitude, longitude)


func control_scroll() -> void:
	
	if Input.is_action_just_pressed("scroll_up"):
		reset_tween()
		var new_zoom = camera.zoom + Vector2.ONE * SCROLL_PACE
		tween.tween_property(camera, "zoom", new_zoom, SCROLL_SPEED)
		
	if Input.is_action_just_pressed("scroll_down"):
		
		if camera.zoom <= Vector2.ONE * 2 * SCROLL_PACE:
			return
		
		reset_tween()
		var new_zoom = camera.zoom - Vector2.ONE * SCROLL_PACE
		tween.tween_property(camera, "zoom", new_zoom, SCROLL_SPEED)


func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
