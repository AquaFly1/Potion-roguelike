extends Node2D

class_name Card

@onready var card_sprite: TextureRect = $Control/Sprite2D

@export var ingredient: Ingredient

@export var control: Control

func _ready() -> void:
	card_sprite.texture = ingredient.sprite

func _on_button_pressed() -> void:
	Game.card_selected.emit(self)

#controlling path	
var path_pos_index: float 
var path: PathFollow2D
@onready var Target_Obj: Marker2D = path.get_child(0)
var times_triggered = 0
var follow_path_tween
	

func move_to_position():
	#var tween = create_tween()
	#tween.tween_property(self, "position", pos, 0.3)
	follow_path_tween = create_tween()
	follow_path_tween.set_ease(Tween.EASE_OUT)
	follow_path_tween.set_trans(4) #elastic
	path.progress_ratio = path_pos_index
	follow_path_tween.tween_property(self, "global_transform", Target_Obj.global_transform,0.2)
	set("z_index",-11-path_pos_index*5)
