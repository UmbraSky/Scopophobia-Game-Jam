extends Area2D

@export var required_item: String
@export var used_texture: Texture
@export var scene_name: String = ""

@onready var sprite: Sprite2D = $Sprite2D
@onready var number_label: Label = get_node_or_null("NumberLabel")
@onready var prompt_label: Label = get_node_or_null("PromptLabel")

var can_interact: bool = false
var used: bool = false

func _ready():
	if number_label:
		number_label.visible = false
	if prompt_label:
		prompt_label.visible = false
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node) -> void:
	print("Body entered:", body.name)
	if body.is_in_group("player"):
		print("Player can interact!")
		can_interact = true
		if prompt_label:
			prompt_label.visible = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		can_interact = false
		if prompt_label:
			prompt_label.visible = false

func _process(_delta: float) -> void:
	if can_interact and not used and Input.is_action_just_pressed("ui_accept"):
		print("Trying to use item:", required_item)
		print("Has item?", Inventory.has_item(required_item))
		print("Scene name:", scene_name)
		print("Code already assigned?", Inventory.code_numbers[scene_name])
		
		if Inventory.has_item(required_item):
			var number = Inventory.use_item(required_item)
			if number != -1:
				sprite.texture = used_texture
				show_number(number)
				used = true
				if prompt_label:
					prompt_label.visible = false
			else:
				print("Item use failed (maybe already used or bad scene?)")

func show_number(number: int) -> void:
	if number_label:
		number_label.text = str(number)
		number_label.visible = true
