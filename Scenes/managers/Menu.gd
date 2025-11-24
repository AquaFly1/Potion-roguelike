extends Control

class_name Menu

@export var settings_menu: Control

static var controller: Control

func _ready() -> void:
	hide()

func escape():
	controller.back()

func _on_resume_pressed() -> void:
	escape()


func _on_save__quit_pressed() -> void:
	get_tree().quit()
