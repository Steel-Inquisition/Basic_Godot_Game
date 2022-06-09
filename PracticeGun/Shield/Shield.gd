extends Area2D
class_name this_shield

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Shield_area_entered(area):
	if (area is Bullet && visible):
		print("HUH???")
		area.queue_free()
