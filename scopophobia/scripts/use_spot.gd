extends Area2D

@export var required_item: String
@export var reveal_number: String

@export var unused_texture: Texture2D
@export var used_texture: Texture2D

@onready var sprite := $Sprite2D

var used := false

func _ready():
	sprite.texture = unused_texture

func _on_body_entered(body):
	if body.is_in_group("player") and not used:
		if InventoryManager.has_item(required_item):
			used = true
			InventoryManager.remove_item(required_item)
			sprite.texture = used_texture  # 💡 Change the visual to show it's used
			show_number()

func show_number():
	var label = Label.new()
	label.text = "[color=red]%s[/color]" % reveal_number
	label.bbcode_enabled = true
	label.position = Vector2(0, -30)
	add_child(label)
