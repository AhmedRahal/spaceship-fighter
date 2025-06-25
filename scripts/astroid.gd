extends Area2D

var speed: float = 100
var direction: Vector2 = Vector2.ZERO
var explosion = preload("res://scenes/explosion.tscn")
func _ready():
	spawn()
	
func spawn():
	var camera = Common._getCurrentCamera()
	if not camera:
		return 

	# Get screen bounds
	var screen_size = get_viewport().size
	var half_screen = screen_size * 0.5 * camera.zoom
	var top_left = camera.global_position - half_screen
	var bottom_right = camera.global_position + half_screen

	# All 4 screen corners
	var corners = [
		top_left,
		Vector2(bottom_right.x, top_left.y),
		bottom_right,
		Vector2(top_left.x, bottom_right.y)
	]

	# Find the farthest corner from current position
	var farthest_corner = corners[0]
	var max_dist = 0.0

	for corner in corners:
		var dist = position.distance_squared_to(corner)
		if dist > max_dist:
			max_dist = dist
			farthest_corner = corner

	direction = (farthest_corner - global_position).normalized()
	
	# Set direction toward that corner
	
	direction = (farthest_corner - position).normalized()
	get_parent()
func _physics_process(delta):
	#moving logic
	position += direction * speed * delta
#func _on_Area2D_area_entered(area):
func dead(area):
	print(area)
	if area :
		if  area.get("type") == "Bullet":
			area.queue_free()
		if  area.get("type") == "Player":
			area.die()
		var explosion_instance = explosion.instance()
		explosion_instance.position = position
		get_tree().current_scene.add_child(explosion_instance)
		queue_free()
func _on_Area2D_body_entered(area):
	dead(area)
