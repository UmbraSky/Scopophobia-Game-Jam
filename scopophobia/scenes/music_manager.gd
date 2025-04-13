extends Node

@onready var tracks := {
	"main": $Main,  # Ensure the node path matches the scene's structure
	"theater": $Theater,
	"woods": $Woods,
	"carnival": $Carnival
}

var current_track := "main"
var fade_time := 0.5  # Seconds to fade

func _ready():
	for track in tracks.values():
		print(track)  # Debug to see if nodes are assigned correctly
	# Check if all tracks exist to avoid null errors
	for track in tracks.values():
		if track == null:
			print("Error: Music track node is null! Make sure the node paths are correct.")
			return

	# Initialize the current track
	var track = tracks[current_track]
	if track:
		track.volume_db = 0
		track.play()

func crossfade_to(target: String):
	# Validate that target exists and is different from current_track
	if target == current_track or not tracks.has(target):
		print("Error: No track found or trying to fade to the same track.")
		return

	var from = tracks[current_track]
	var to = tracks[target]

	# Check for null before accessing the properties
	if from == null or to == null:
		print("Error: One or more tracks are null!")
		return

	print("Fading from", current_track, "to", target)

	# Play the new track immediately (so it doesn't play late)
	to.play()
	to.volume_db = -80  # Start silent

	# Tween volumes: fade out current track, fade in new track
	var tween = create_tween()
	tween.tween_property(from, "volume_db", -80, fade_time)
	tween.tween_property(to, "volume_db", 0, fade_time)

	# Stop old track after fade
	tween.tween_callback(func():
		from.stop())

	# Update the current track
	current_track = target
	print("Now playing:", target)  # For debugging
