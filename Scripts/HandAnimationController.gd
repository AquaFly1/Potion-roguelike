extends AnimationTree

var Size: float
var NewSize: float
func hand_modified(cards):
	NewSize = float(len(cards))
	print("gotUpdate",Size)
	
	
func _ready() -> void:
	Game.held_hand_modified.connect(hand_modified)
	Size = 0
	NewSize = 0
	
func _process(delta: float) -> void:
	Size = lerp(Size, NewSize, 0.5)
	set("parameters/HoldBlend/TimeSeek/seek_request", Size)
	pass
