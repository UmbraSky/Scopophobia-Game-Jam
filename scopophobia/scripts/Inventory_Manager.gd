extends Node

const MAX_ITEMS := 3
var inventory: Array[String] = []

func add_item(item_name: String) -> bool:
	if item_name in inventory:
		return false  # Already have it
	if inventory.size() < MAX_ITEMS:
		inventory.append(item_name)
		print("Collected:", item_name)
		HUD.update_inventory(inventory)
		return true
	return false

func has_item(item_name: String) -> bool:
	return item_name in inventory

func remove_item(item_name: String) -> void:
	if item_name in inventory:
		inventory.erase(item_name)
		HUD.update_inventory(inventory)
