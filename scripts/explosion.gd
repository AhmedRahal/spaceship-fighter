extends AnimatedSprite

onready var audioStream =  $"../AudioStreamPlayer"

func _ready():
	audioStream.play()
func _on_AnimatedSprite_animation_finished():
	queue_free()
