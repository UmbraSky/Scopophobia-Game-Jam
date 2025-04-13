extends Node

@onready var inventory = $Inventory  # Reference to your Inventory node

func check_win_condition() -> bool:
	# Check if all key items are used
	return !inventory.has_item("key1") and !inventory.has_item("key2") and !inventory.has_item("key3")
