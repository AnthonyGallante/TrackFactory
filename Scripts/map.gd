extends Node2D

# GLOBAL
const MAP_WIDTH: float = 10800.0
const MAP_HEIGHT: float = 5400.0

# MOUSE HOVER
var mouse_loc: Vector2
var coordinate: Vector2

# CAMERA
@onready var camera: Camera2D = $Camera2D
const MINIMUM_ZOOM: Vector2 = Vector2(0.150, 0.150)
const MAXIMUM_ZOOM: Vector2 = Vector2(125.0, 125.0)
var scroll_pace := Vector2(0.07, 0.07)


func _process(_delta: float) -> void:
	
	mouse_loc = get_global_mouse_position()
	coordinate = pixel_to_latlon(mouse_loc.x, mouse_loc.y)
	
	_control_scroll()
	_control_grid()
	
	prints("Distance from Equator (m)", haversine(0, 0, coordinate.x, coordinate.y))


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


func haversine(lat1, lon1, lat2, lon2):
	var R = 6371000  # Radius of Earth in meters

	# Convert latitude and longitude from degrees to radians
	var lat1_rad = deg_to_rad(lat1)
	var lon1_rad = deg_to_rad(lon1)
	var lat2_rad = deg_to_rad(lat2)
	var lon2_rad = deg_to_rad(lon2)

	# Differences in coordinates
	var delta_lon = lon2_rad - lon1_rad
	var delta_lat = lat2_rad - lat1_rad

	# Haversine formula
	var a = sin(delta_lat / 2) ** 2 + cos(lat1_rad) * cos(lat2_rad) * sin(delta_lon / 2) ** 2 
	var c = 2 * atan2(sqrt(a), sqrt(1 - a))

	return R * c


func _control_scroll() -> void:
	# Scrolling into the map
	if Input.is_action_just_pressed("scroll_up"):
		if camera.zoom >= MAXIMUM_ZOOM:
			return
		elif camera.zoom > Vector2.ONE:
			camera.zoom += scroll_pace * 10
		else:
			camera.zoom += scroll_pace
	
	# Scrolling out of the map
	if Input.is_action_just_pressed("scroll_down"):
		if camera.zoom <= MINIMUM_ZOOM:
			return
		elif camera.zoom > Vector2.ONE:
			camera.zoom -= scroll_pace * 10
		else:
			camera.zoom -= scroll_pace


func _control_grid():
	$Camera2D/PlainGrid.modulate.a = (camera.zoom.x / 50) - 0.25
