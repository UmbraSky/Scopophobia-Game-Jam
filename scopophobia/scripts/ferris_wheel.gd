extends Node2D

@export var radius: float = 100.0
@export var speed: float = 0.5  # Slower speed for easier player reaction
@export var clockwise: bool = true
@export var start_step: int = 0
@export var steps_per_rotation: int = 4  # Total positions (4 = quarter steps)

var platforms: Array[Node2D] = []
var current_step: float = 0.0  # Change to float for smoother step handling
var angle_step: float

func _ready():
	# Get all direct children as platforms
	for child in get_children():
		if child is Node2D:
			platforms.append(child)

	current_step = float(start_step)  # Ensure current_step is a float
	angle_step = TAU / steps_per_rotation  # full rotation divided by the number of steps

func _process(delta):
	# Constant rotation: platforms will keep moving continuously
	var direction = 1 if clockwise else -1
	var rotation_angle = angle_step * direction * speed * delta  # Smooth rotation based on time

	# Move all platforms gradually
	for i in range(platforms.size()):
		var angle = angle_step * (current_step + i) + rotation_angle
		var offset = Vector2(cos(angle), sin(angle)) * radius
		platforms[i].global_position = global_position + offset

	# Update current_step and handle looping without using % on float
	current_step += direction * speed * delta
	if current_step >= steps_per_rotation:
		current_step -= steps_per_rotation
	elif current_step < 0:
		current_step += steps_per_rotation
