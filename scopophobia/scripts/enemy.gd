extends CharacterBody2D

@export var speed = 200
@export var player: CharacterBody2D
@onready var nav_agen := $NavigationAgent2D as NavigationAgent2D

func _physics_process(_delta: float) -> void:
	var direction = to_local(nav_agen.get_next_path_position()).normalized()
	velocity = direction * speed
	move_and_slide()
	
func make_path() -> void:
	nav_agen.target_position = player.global_position

func _on_timer_timeout() -> void:
	make_path()
