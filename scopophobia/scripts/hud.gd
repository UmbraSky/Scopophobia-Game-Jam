extends CanvasLayer

@onready var countdown_label: Label = $CountdownLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var top_lid: ColorRect = $TopLid
@onready var bottom_lid: ColorRect = $BottomLid

@onready var hearts_container := $"HeartsContainer"  # Node with Sprite or TextureRects as hearts

func update_hearts(hearts: int):
	for i in hearts_container.get_child_count():
		var heart = hearts_container.get_child(i)
		heart.visible = i < hearts

var transition_stage := 0

func set_countdown_text(text: String):
	if countdown_label:
		countdown_label.text = text

func play_transition():
	if transition_stage == 0:
		animation_player.play("eyes_close")
		transition_stage = 1
	elif transition_stage == 1:
		animation_player.play("eyes_open")
		transition_stage = 0
