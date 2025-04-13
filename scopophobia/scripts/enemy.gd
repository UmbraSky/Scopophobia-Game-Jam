extends CharacterBody2D

@export var speed = 200
@export var player: CharacterBody2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var damage_area: Area2D = $DamageArea  # Add this Area2D as a child with a shape

func _ready():
	damage_area.body_entered.connect(_on_damage_area_body_entered)

func _physics_process(_delta: float) -> void:
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * speed

	# Flip sprite based on direction
	if direction.x > 0:
		sprite_2d.flip_h = true
	elif direction.x < 0:
		sprite_2d.flip_h = false

	move_and_slide()

func make_path() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	make_path()

func _on_damage_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("Enemy hit the player!")
		body.on_fall_out_of_world()
