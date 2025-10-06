extends AnimationTree

var Size: float
var NewSize: float
var CurrentSize: float
var time: float
var timeSmooth: float
@onready var animationPlayer: AnimationPlayer = $"../AnimationPlayer"
@onready var hold_anim_length: float = animationPlayer.get_animation("RHHoldCards").length
@onready var state_machine = self["parameters/playback"]
var is_in_interaction: bool = false

func hand_modified(cards):
	Size = CurrentSize
	time = 0
	NewSize = (float(len(cards)-1)/4) * hold_anim_length
	
	
func set_hand_size() -> void:
	set("parameters/HoldBlend/TimeSeek/seek_request", CurrentSize)

func player_start() -> void:
	is_in_interaction = true
	state_machine.travel("ArmRightPickup")

func interaction_ended() -> void:
	is_in_interaction = false
	state_machine.travel("Start")

func _ready() -> void:
	Game.held_hand_modified.connect(hand_modified)
	Game.player_start_turn.connect(player_start)
	Game.interaction_ended.connect(interaction_ended)
	Size = 0
	NewSize = 0
	CurrentSize = 0
	time = 1
	
func _process(delta: float) -> void:
	if time < 1:
		time = clampf(time+2*delta,0,1)
	timeSmooth = cubic_ease_in_out(time)
	CurrentSize = lerp(Size, NewSize, timeSmooth)
	set("parameters/HoldBlend/TimeSeek/seek_request", CurrentSize)
	pass
	
func cubic_ease_in_out(t: float) -> float:
	if t < 0.5:
		return 4.0 * t * t * t
	else:
		return 1.0 - pow(-2.0 * t + 2.0, 3) / 2.0
