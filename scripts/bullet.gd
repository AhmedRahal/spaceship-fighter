extends Area2D
class_name Bullet
var type = "Bullet"
var speed:float = 1200
var direction:Vector2 = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	position += direction *speed *delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		var camera = Common._getCurrentCamera()
		die(camera)

func die(camera: Camera2D):
	if not camera:
		return
	var pos:Vector2 = global_position
	if Common.is_in_view(pos,camera):
		queue_free()
