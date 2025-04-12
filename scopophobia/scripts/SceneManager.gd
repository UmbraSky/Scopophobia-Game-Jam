extends Node

var player_position: Vector2 = Vector2.ZERO
var player_scene_path: String = ""

# Optional: store data between scenes (e.g., inventory, health, etc.)
var player_state: Dictionary = {}

func switch_to_scene(scene_path: String):
	if not ResourceLoader.exists(scene_path):
		push_error("Scene path does not exist: " + scene_path)
		return

	var new_scene = load(scene_path).instantiate()

	# Reposition the player if one exists in the new scene
	var player = new_scene.get_node_or_null("Player")
	if player:
		player.global_position = player_position

	get_tree().root.add_child(new_scene)

	# Clean up old scene
	var old_scene = get_tree().current_scene
	if old_scene:
		old_scene.queue_free()

	get_tree().current_scene = new_scene
