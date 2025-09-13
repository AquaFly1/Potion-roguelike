extends AnimationTree


func hand_modified(cards):
	print(cards)
	
func _ready() -> void:
	Game.held_hand_modified.connect(hand_modified)
