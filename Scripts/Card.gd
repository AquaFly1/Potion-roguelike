extends Control

class_name Card

@onready var card_sprite: TextureRect = $TransformBase/Sprite2D

@export var ingredient: Ingredient



func _ready() -> void:
	card_sprite.texture = ingredient.sprite


func _on_button_pressed() -> void:
	Game.card_selected.emit(self)

#controlling path	
var path_pos_index: float 
var path: PathFollow2D
@onready var Target_Obj: Marker2D = path.get_child(0)
@export var transformBase: Marker2D
var times_triggered = 0

func move_to_position(pos: Vector2):
	#var tween = create_tween()
	#tween.tween_property(self, "position", pos, 0.3)
	
	var follow_path_tween = create_tween()
	path.progress_ratio = path_pos_index
	follow_path_tween.tween_property(transformBase, "global_transform", Target_Obj.global_transform,0.4)
	print(transformBase.global_position)
	print(Target_Obj.global_position)
	#transformBase.global_position = Target_Obj.global_position
