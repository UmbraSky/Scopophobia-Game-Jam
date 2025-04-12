extends Area2D

@export var platform_id: int
@export var scene_to_load: PackedScene

func _ready():
	pass


func _on_area_entered(area: Area2D):
	# Go up the node tree to see if this Area2D belongs to the Player
	var player = area.get_parent()
	if player and player.is_in_group("player"):
		print("Player entered platform ", platform_id)
		player.current_platform_id = platform_id
		player.register_platform(platform_id, scene_to_load)
		print("Current Player Platform ID: ", player.current_platform_id)

func _on_area_exited(area: Area2D):
	var player = area.get_parent()
	if player and player.is_in_group("player"):
		if player.current_platform_id == platform_id:
			print("Player exited platform ", platform_id)
			player.current_platform_id = -1
			print("Current Player Platform ID: ", player.current_platform_id)
