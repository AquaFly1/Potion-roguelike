extends Node2D

class_name Card

@export var card_sprite: TextureRect

@onready var base_sprite_pos: Vector2 = card_sprite.position

@export var ingredient: Ingredient

@export var control: Control


func _ready() -> void:
	Game.held_chand_modified.connect(chand_modified)
	card_sprite.texture = ingredient.sprite
	

func _on_button_pressed() -> void:
	Game.card_selected.emit(self)

#controlling path	
var path_pos_index: float 
var path: PathFollow2D
@onready var Target_Obj: RemoteTransform2D = path.get_child(0)
var times_triggered = 0
var follow_path_tween: Tween
var lift_tween: Tween
var chand_size = 5
var saved_ratio: float = 0


func chand_modified(cards):
	chand_size = cards.size()

func move_to_position():
	follow_path_tween = create_tween()
	follow_path_tween.set_ease(Tween.EASE_OUT)
	follow_path_tween.set_trans(Tween.TRANS_QUAD)
	follow_path_tween.tween_property(self,"saved_ratio",path_pos_index/max(4,chand_size-1),0.2)
	set("z_index",-11-path_pos_index)

func _process(_delta: float) -> void:
	path.progress_ratio = saved_ratio


func _on_button_mouse_entered() -> void:
	lift_tween = create_tween()
	lift_tween.set_ease(Tween.EASE_OUT)
	lift_tween.set_trans(Tween.TRANS_QUAD)
	lift_tween.tween_property(card_sprite,"position",base_sprite_pos+Vector2(0,-15),0.1)
	set("z_index",-10)


func _on_button_mouse_exited() -> void:
	lift_tween = create_tween()
	lift_tween.set_ease(Tween.EASE_OUT)
	lift_tween.set_trans(Tween.TRANS_QUAD)
	lift_tween.tween_property(card_sprite,"position",base_sprite_pos +  Vector2(0,0),0.1)
	set("z_index",-11-path_pos_index)


func _on_card_button_down() -> void:
	Game.card_pressed.emit(self)
