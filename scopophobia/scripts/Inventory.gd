extends Node

signal inventory_updated

var items = {
	"skull": false,
	"ax": false,
	"ballons": false
}

var code_numbers = {
	"test1": null,
	"test2": null,
	"test3": null
}

func collect_item(item_name: String) -> void:
	if items.has(item_name):
		items[item_name] = true
		emit_signal("inventory_updated")

func has_item(item_name: String) -> bool:
	return items.get(item_name, false)

func use_item(scene_name: String, item_name: String) -> int:
	if has_item(item_name) and code_numbers[scene_name] == null:
		items[item_name] = false
		var number = randi() % 9 + 1
		code_numbers[scene_name] = number
		emit_signal("inventory_updated")
		return number
	return -1  # Invalid or already used

func get_code() -> Dictionary:
	return code_numbers
