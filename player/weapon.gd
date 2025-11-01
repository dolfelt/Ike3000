extends Area2D

@export var WeaponID: int = 0

var speed = 500

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
