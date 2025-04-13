extends Node

var last_hub_position: Vector2 = Vector2.ZERO
const HUB_SCENE_PATH := "res://scenes/main.tscn"
const test1 := "res://scenes/test1.tscn"
const test2 := "res://scenes/test2.tscn"
const test3 := "res://scenes/test3.tscn"

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
		
		# Ensure MusicManager is initialized before transitioning
		var music_manager = new_scene.get_node_or_null("MusicManager")
		if music_manager == null:
			print("Error: MusicManager is not found in the new scene!")
			return  # Exit early if MusicManager is not found

		# Proceed with music transition
		if path == HUB_SCENE_PATH:
			print("Switching to HUB scene, playing main music.")
			music_manager.crossfade_to("main")
		elif path == test1:
			print("Switching to test1, playing theater music.")
			music_manager.crossfade_to("theater")
		elif path == test2:
			print("Switching to test2, playing woods music.")
			music_manager.crossfade_to("woods")
		elif path == test3:
			print("Switching to test3, playing carnival music.")
			music_manager.crossfade_to("carnival")

		# Set player spawn position
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
