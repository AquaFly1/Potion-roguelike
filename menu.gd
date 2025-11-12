extends Control

@onready var label: Label = $Label


func _on_resume_pressed() -> void:
	queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_save__quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	label.visible = true
