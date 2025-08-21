extends GraphEdit

@export var scroll_limit_rect: Rect2

func _process(_delta):
	var current_scroll_offset = get_scroll_offset()

	# Clamp the x-axis
	current_scroll_offset.x = clamp(current_scroll_offset.x, scroll_limit_rect.position.x, scroll_limit_rect.position.x + scroll_limit_rect.size.x - get_size().x)

	# Clamp the y-axis
	current_scroll_offset.y = clamp(current_scroll_offset.y, scroll_limit_rect.position.y, scroll_limit_rect.position.y + scroll_limit_rect.size.y - get_size().y)

	set_scroll_offset(current_scroll_offset)
