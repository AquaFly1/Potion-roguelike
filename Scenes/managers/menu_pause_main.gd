extends Menu

@export var settings_menu: Control

func escape():
	controller.back()


func _on_resume_pressed() -> void:
	escape()


func _on_save__quit_pressed() -> void:
	get_tree().quit()
