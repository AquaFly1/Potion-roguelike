extends AnimationTree

var Size: float
var NewSize: float
var CurrentSize: float
var time: float
var timeSmooth: float

func hand_modified(cards):
	Size = CurrentSize
	time = 0
	NewSize = float(len(cards)-1)/5
	
	
func _ready() -> void:
	Game.held_hand_modified.connect(hand_modified)
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
