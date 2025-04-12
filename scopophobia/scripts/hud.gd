extends CanvasLayer

@onready var countdown_label: Label = $CountdownLabel

func set_countdown_text(text: String):
	if countdown_label:
		countdown_label.text = text
