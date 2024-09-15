extends Camera2D
@export
var ZOOM_FACTOR=0.5
# Function to zoom at a specific point
func zoom_at_point(target_point: Vector2, zoom_factor: float):
	# Current zoom and offset
	



	# Calculate the new zoom
	var new_zoom = zoom * zoom_factor
	var viewport_size=get_viewport_rect().size
	var new_offset =  lerp(offset,(target_point + offset - viewport_size/ 2),min(1,ZOOM_FACTOR/zoom.x))
	

	# Apply the new zoom and offset
	zoom = new_zoom
	offset = new_offset

# Example usage
