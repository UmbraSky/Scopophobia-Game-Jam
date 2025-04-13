extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SceneManager.switch_to_scene(SceneManager.HUB_SCENE_PATH)
