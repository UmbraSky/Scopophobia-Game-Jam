extends Area2D

@export var item_name: String
var can_interact := false
@onready var prompt_label: Label = $PromptLabel  # Assign in scene

func _ready():
	prompt_label.visible = false
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	print("Body entered:", body.name)
	if body.is_in_group("player"):
		print("Player can interact!")
		can_interact = true
		prompt_label.visible = true

func _on_body_exited(_body):
	can_interact = false
	prompt_label.visible = false

func _process(_delta):
	if can_interact and Input.is_action_just_pressed("ui_accept"):
		if not Inventory.has_item(item_name):
			Inventory.collect_item(item_name)
			queue_free()
