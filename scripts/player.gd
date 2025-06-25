extends KinematicBody2D
class_name Player
var type = "Player"
export var speed: float = 300.00
var bulletScene = null
var explosion = preload("res://scenes/explosion.tscn")
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

func die():
	visible = false
	var explosion_instance = explosion.instance()
	explosion_instance.position = position
	get_tree().current_scene.add_child(explosion_instance)
	
	var timer = Timer.new()
	timer.wait_time = 1
	timer.one_shot = true
	get_tree().current_scene.add_child(timer)

	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()

func _on_timer_timeout():
	print("Timer ended")
	get_tree().paused = true
	queue_free()




