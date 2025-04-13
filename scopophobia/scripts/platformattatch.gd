extends Node2D

var player: CharacterBody2D = null
var last_position: Vector2 = Vector2.ZERO

func _on_area_entered(area: Area2D):
	if area.get_parent().is_in_group("player"):
		player = area.get_parent()

func _on_area_exited(area: Area2D):
	if area.get_parent().is_in_group("player"):
		player = null

func _process(delta):
	if player:
		var platform = get_parent()
		# Calculate velocity based on platform movement
		var velocity = platform.global_position - last_position
		last_position = platform.global_position
		# Move player along with the platform
		player.global_position += velocity
