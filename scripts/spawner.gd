extends TextureRect

# Global variables
onready var timer = $Timer
var waitTime: float = 5
var astroid_spawned: int = 0
var times: int = 1

func _ready():
	randomize()
	timer.start()

func _on_Timer_timeout():
	astroid_spawned += 1
	spawn_handler()

func spawn_handler():
	for i in range(times):
		spawn()

func spawn():
	var r = floor(rand_range(1, 3)) # random 1 or 2
	var asteroid_scene = load("res://scenes/aestroid0%d.tscn" % r)
	var asteroid = asteroid_scene.instance()
	get_parent().add_child(asteroid)
	asteroid.scale = Vector2(2, 2)

	var cam = Common._getCurrentCamera()
	var spawn_pos = get_random_screen_edge_position(cam)
	asteroid.position = spawn_pos
	
	# Move direction: toward camera center
	var target_pos = cam.global_position
	var direction = (target_pos - spawn_pos).normalized()
	asteroid.set("direction", direction)
	# Add to group for later die call
	asteroid.add_to_group("asteroids")

func get_random_screen_edge_position(camera: Camera2D) -> Vector2:
	var screen_size = get_viewport().size
	var half_screen = screen_size * 0.5 * camera.zoom
	var top_left = camera.global_position - half_screen
	var bottom_right = camera.global_position + half_screen

	var edge = randi() % 4
	var x = 0.0
	var y = 0.0

	match edge:
		0:
			x = rand_range(top_left.x, bottom_right.x)
			y = top_left.y
		1:
			x = bottom_right.x
			y = rand_range(top_left.y, bottom_right.y)
		2:
			x = rand_range(top_left.x, bottom_right.x)
			y = bottom_right.y
		3:
			x = top_left.x
			y = rand_range(top_left.y, bottom_right.y)

	return Vector2(x, y)

func die(camera: Camera2D, position_instance: Vector2):
	if not camera:
		return
	if not Common.is_in_view(position_instance, camera):
		queue_free()

func kill_all_asteroids():
	for asteroid in get_tree().get_nodes_in_group("asteroids"):
		var cam = Common._getCurrentCamera()
		if asteroid.has_method("die"):
			asteroid.die(cam, asteroid.global_position)
