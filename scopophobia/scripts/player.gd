extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var countdown_duration := 10.0  # seconds

@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D

var current_platform_id: int 
var platform_scenes := {}  


func _ready():
	timer.wait_time = countdown_duration
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	set_process(true)
	
func _input(event):
	if timer.time_left > 0:
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			print("Switching Scenes Manually!")
			
			if get_tree().current_scene.name != "Main" and current_platform_id <= 0:
				SceneManager.player_position = self.global_position
				SceneManager.switch_to_scene("res://scenes/main.tscn")
			
			else:
				if platform_scenes.has(current_platform_id):
					var scene = platform_scenes[current_platform_id]
					SceneManager.player_position = self.global_position
					SceneManager.switch_to_scene(scene.resource_path)

func register_platform(platform_id: int, scene: PackedScene):
	platform_scenes[platform_id] = scene  # Register the scene for this platform

func _process(_delta):
	if timer.time_left > 0:
		HUD.set_countdown_text("Time Left: " + str(round(timer.time_left)) + "s")
	else:
		HUD.set_countdown_text("")  # Clear when done

func _physics_process(delta: float) -> void:
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle horizontal movement.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction > 0:
		sprite_2d.flip_h = true 
	if direction < 0:
		sprite_2d.flip_h = false

	move_and_slide()

func _on_timer_timeout():
	print("Timer finished. Current platform ID: ", current_platform_id)

	if platform_scenes.has(current_platform_id):
		var scene = platform_scenes[current_platform_id]
		SceneManager.player_position = self.global_position
		SceneManager.switch_to_scene(scene.resource_path)
	else:
		if get_tree().current_scene.name != "Main" and current_platform_id == 0:
			SceneManager.player_position = self.global_position
			SceneManager.switch_to_scene("res://scenes/main.tscn")
