extends Node2D

class_name Card

@onready var card_sprite: TextureRect = $Control/Sprite2D

@export var ingredient: Ingredient

@export var control: Control

func _ready() -> void:
	Game.held_hand_modified.connect(hand_modified)
	card_sprite.texture = ingredient.sprite

func _on_button_pressed() -> void:
	Game.card_selected.emit(self)

#controlling path	
var path_pos_index: float 
var path: PathFollow2D
@onready var Target_Obj: RemoteTransform2D = path.get_child(0)
var times_triggered = 0
var follow_path_tween: Tween
var hand_size = 5
var saved_ratio: float = 0

func hand_modified(cards):
	hand_size = cards.size()

func move_to_position():
	follow_path_tween = create_tween()
	follow_path_tween.set_ease(Tween.EASE_OUT)
	follow_path_tween.set_trans(Tween.TRANS_QUAD)
	print(path_pos_index/max(4,hand_size-1))
	follow_path_tween.tween_property(self,"saved_ratio",path_pos_index/max(4,hand_size-1),0.2)
	set("z_index",-11-path_pos_index)

func _process(_delta: float) -> void:
	path.progress_ratio = saved_ratio
