extends Area2D
class_name Bullet

signal enemy_hit

var speed = 700
var damage = 10

func _physics_process(delta):
	  position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if (body is map):
		queue_free()
	elif (body is this_player):
		body.take_damage(damage)
		queue_free()
	elif (body is enemy):
		body.take_damage(damage)
		queue_free()
