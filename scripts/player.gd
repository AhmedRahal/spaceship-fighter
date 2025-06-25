extends KinematicBody2D

export var speed: float = 100.0
var bulletScene = null
var shooting_cd:float = -0.0
func _ready():
	bulletScene = preload("res://scenes/bullet.tscn")
	
func _physics_process(delta):
	if not Common.is_in_view(position,Common._getCurrentCamera()):
		var vector:Vector2 = Input.get_vector('left','right','up','down')
		move_and_collide(vector*speed*delta) 
		shoot(delta)


func _process(delta):
	var direction = get_global_mouse_position() - global_position
	rotation = direction.angle() + deg2rad(90)



func shoot(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT)  and shooting_cd <= 0:
		shooting_cd = .5
		var bullet = bulletScene.instance()
		bullet.global_position = global_position
		get_parent().add_child(bullet)
		var direction = (get_global_mouse_position() - global_position).normalized()
		bullet.direction = direction
	elif shooting_cd >0:
		shooting_cd -= delta

func get_screen_borders() :
	pass





