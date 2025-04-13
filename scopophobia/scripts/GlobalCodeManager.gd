extends Node

var revealed_code: Array[int] = []

func reset_code():
	revealed_code.clear()

func add_number(number: int):
	if revealed_code.size() < 3:
		revealed_code.append(number)

func get_code() -> Array[int]:
	return revealed_code
