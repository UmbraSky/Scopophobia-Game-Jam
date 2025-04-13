extends Node

@onready var tracks := {
	"main": $Main,
	"theater": $Theater,
	"woods": $Woods,
	"carnival": $Carnival
}

var current_track := "main"
var fade_time := 2.0  # Seconds to fade

func _ready():
	tracks[current_track].volume_db = 0
	tracks[current_track].play()

func crossfade_to(target: String):
	if target == current_track or not tracks.has(target):
		return

	var from = tracks[current_track]
	var to = tracks[target]

	to.play()
	to.volume_db = -80  # Start silent

	# Tween volumes
	var tween = create_tween()
	tween.tween_property(from, "volume_db", -80, fade_time)
	tween.tween_property(to, "volume_db", 0, fade_time)

	# Stop old track after fade
	tween.tween_callback(func(): from.stop())

	current_track = target
