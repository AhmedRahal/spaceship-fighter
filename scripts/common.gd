extends Node

func is_in_view(pos,camera):
	var screen_size = get_viewport().size
	var half_screen = screen_size * 0.5 * camera.zoom
	
	var top_left = camera.global_position - half_screen
	var bottom_right = camera.global_position + half_screen
	if pos.x < top_left.x or pos.x > bottom_right.x \
	or pos.y < top_left.y or pos.y > bottom_right.y:
		return true
	return false
func _getCurrentCamera():
	var cameras = get_tree().get_nodes_in_group('cameras')
	for camera in cameras :
		if camera is Camera2D and camera.current :
			return camera
	return null
