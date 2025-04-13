extends Area2D

func _on_body_entered(body):
	print("Player fell out of bounds!")
	if body.is_in_group("player"):
		body.on_fall_out_of_world()
