extends CharacterBody2D

@export var SPEED := 300.0
@export var JUMP_VELOCITY := -400.0
@export var countdown_duration := 10.0  # seconds
@export var acceleration := 800.0  # How quickly the player accelerates
@export var deceleration := 600.0  # How quickly the player decelerates when not moving

@onready var timer: Timer = $Timer
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var current_platform_id: int
var platform_scenes := {}

func _ready():
	add_to_group("player")
	timer.wait_time = countdown_duration
	timer.timeout.connect(_on_timer_timeout)
	set_process(true)
	HUD.update_hearts(GameState.hearts)

	# Start the timer ONLY if we're starting directly in the HUB
	if get_tree().current_scene.name == "Main":
		timer.start()

var can_leave_platform := false

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var is_in_hub := get_tree().current_scene.name == "Main"

		# In HUB scene, allow switching at any time
		if is_in_hub:
			if platform_scenes.has(current_platform_id):
				print("Switching from HUB to platform!")
				HUD.play_transition()
				await get_tree().create_timer(0.5).timeout
				var scene = platform_scenes[current_platform_id]
				SceneManager.switch_to_scene(scene.resource_path, self.global_position)

		# In platform scenes, only allow switching AFTER timer ends
		elif can_leave_platform:
			print("Returning to HUB from platform!")
			HUD.play_transition()
			SceneManager.switch_to_scene(SceneManager.HUB_SCENE_PATH)

func register_platform(platform_id: int, scene: PackedScene):
	platform_scenes[platform_id] = scene  # Register the scene for this platform

func _process(_delta):
	if timer.is_stopped() and can_leave_platform:
		HUD.set_countdown_text("Time's Up!")
	elif timer.time_left > 0:
		HUD.set_countdown_text("Time Left: " + str(round(timer.time_left)) + "s")
	else:
		HUD.set_countdown_text("")  # Optional fallback

func _physics_process(delta: float) -> void:
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle horizontal movement with acceleration and deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		# Accelerate towards target speed
		velocity.x = move_toward(velocity.x, direction * SPEED, acceleration * delta)
	else:
		# Decelerate towards zero when no input
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	
	# Flip sprite depending on direction
	if direction > 0:
		sprite_2d.flip_h = true 
	if direction < 0:
		sprite_2d.flip_h = false
	
	var run_state : bool = false
	if (direction < 0 or direction > 0) and sprite_2d.animation != "Run":
		sprite_2d.play("Run")
	elif direction == 0:
		sprite_2d.play("Idle")
	move_and_slide()

func _on_timer_timeout():
	print("Timer finished. Current platform ID: ", current_platform_id)

	var is_in_hub := get_tree().current_scene.name == "Main"

	if is_in_hub:
		if platform_scenes.has(current_platform_id):
			HUD.play_transition()
			await get_tree().create_timer(0.5).timeout
			var scene = platform_scenes[current_platform_id]
			SceneManager.switch_to_scene(scene.resource_path, self.global_position)
		else:
			print("No valid platform scene assigned to current platform ID.")
	else:
		print("Timer ended in a platform scene — waiting for manual return.")
		can_leave_platform = true
		timer.stop()

func on_fall_out_of_world():
	if GameState.hearts > 0:
		GameState.hearts -= 1
		HUD.update_hearts(GameState.hearts)

	if GameState.hearts <= 0:
		print("Player died!")
		# Handle game over
	else:
		HUD.play_transition()
		SceneManager.switch_to_scene(SceneManager.HUB_SCENE_PATH)
