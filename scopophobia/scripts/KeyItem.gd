extends Area2D

@export var item_name: String
@onready var sprite := $Sprite2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		if InventoryManager.add_item(item_name):
			queue_free()  # Remove after pickup
