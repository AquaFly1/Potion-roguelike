extends Control

@onready var input_label: Label = $buttons/Input

var tween: Tween

var input: String

func _ready() -> void:
	tween = create_tween()
	tween.tween_interval(0)

func input_button(key: String):
	if len(input) < 3 and not tween.is_running():
		input += key
		update_text()

func update_text():
	input_label.text = input
	if len(input) == 3:
		tween = create_tween()
		tween.tween_interval(0.5)
		await tween.finished
		input = ""
		input_label.text = input
		
