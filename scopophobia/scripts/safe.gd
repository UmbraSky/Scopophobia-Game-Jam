extends Area2D

# Optional: Signal for winning the game
signal code_correct

# You can define the correct values however you want (or set them in the inspector)
var correct_code = Inventory.get_code()


func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	var player_code = Inventory.get_code()

	print("Entered Safe - Player Code:", player_code)
	print("Correct Code:", correct_code)

	# Check if all parts of the code match
	var all_match := true
	for scene_name in correct_code.keys():
		if player_code[scene_name] != correct_code[scene_name]:
			all_match = false
			break

	if all_match:
		print("Correct code! You win!")
		emit_signal("code_correct")
		# TODO: Call win screen or ending
	else:
		print("Incorrect code. Try again.")
