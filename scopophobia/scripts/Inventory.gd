extends Node

signal inventory_updated

var items = {
	"key1": false,
	"key2": false,
	"key3": false
}

func collect_item(item_name: String) -> void:
	if items.has(item_name):
		items[item_name] = true
		emit_signal("inventory_updated")

func has_item(item_name: String) -> bool:
	return items.get(item_name, false)

func use_item(item_name: String) -> bool:
	if has_item(item_name):
		items[item_name] = false  # Mark as used
		emit_signal("inventory_updated")
		return true
	return false  # Invalid use
