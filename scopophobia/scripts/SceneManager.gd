extends Node

var last_hub_position: Vector2 = Vector2.ZERO
const HUB_SCENE_PATH := "res://scenes/main.tscn"

func switch_to_scene(path: String, new_position := Vector2.ZERO):
	var packed_scene = load(path)
	if packed_scene:
		var current = get_tree().current_scene
		if current and current.scene_file_path == HUB_SCENE_PATH:
			last_hub_position = new_position  # Save position in HUB

		var new_scene = packed_scene.instantiate()

		if current:
			current.queue_free()

		get_tree().root.add_child(new_scene)
		get_tree().current_scene = new_scene

		await get_tree().process_frame  # Ensure everything is loaded

		var player = new_scene.get_node_or_null("Player")
		if player:
			if path == HUB_SCENE_PATH:
				player.global_position = last_hub_position
				player.timer.start()  # Only reset timer in HUB scene
			else:
				var spawn_point = new_scene.get_node_or_null("SpawnPoint")
				if spawn_point:
					player.global_position = spawn_point.global_position
				else:
					player.global_position = Vector2.ZERO  # fallback
