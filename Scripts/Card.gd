extends Control

class_name Card

@onready var card_sprite: TextureRect = $Sprite2D

@export var ingredient: Ingredient

func _ready() -> void:
	card_sprite.texture = ingredient.sprite


func _on_button_pressed() -> void:
	Game.card_selected.emit(self)

func move_to_position(pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", pos, 0.3)
	
