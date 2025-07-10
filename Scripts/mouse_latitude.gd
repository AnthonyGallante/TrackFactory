extends Label

@onready var map: Node2D = $"../../../MapNode/SubViewportContainer/SubViewport/Map"

func _process(_delta: float) -> void:
	text = "%.5f, %.5f" % [map.coordinate.x, map.coordinate.y]
