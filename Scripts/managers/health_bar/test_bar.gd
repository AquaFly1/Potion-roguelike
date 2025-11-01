extends Control

@onready var health_bar: HBoxContainer = $health_bar

@onready var ba: Label = $ba
@onready var pa: Label = $pa
@onready var ra: Label = $ra
@onready var sa: Label = $sa
@onready var fa: Label = $fa
@onready var ha: Label = $ha

func _process(_delta: float) -> void:
	ba.text = str(health_bar.burn)
	pa.text = str(health_bar.poison)
	ra.text = str(health_bar.rejuv)
	sa.text = str(health_bar.shield)
	fa.text = str(health_bar.freeze)
	ha.text = str(health_bar.health)
	


func _on_burn_up_pressed() -> void:
	health_bar.burn += 1


func _on_burn_down_pressed() -> void:
	health_bar.burn -= 1


func _on_poison_up_pressed() -> void:
	health_bar.poison += 1


func _on_poison_down_pressed() -> void:
	health_bar.poison -= 1


func _on_rejuv_up_pressed() -> void:
	health_bar.rejuv += 1


func _on_rejuv_down_pressed() -> void:
	health_bar.rejuv -= 1


func _on_shield_up_pressed() -> void:
	health_bar.shield += 1


func _on_shield_down_pressed() -> void:
	health_bar.shield -= 1


func _on_freeze_up_pressed() -> void:
	health_bar.freeze += 1


func _on_freeze_down_pressed() -> void:
	health_bar.freeze -= 1


func _on_health_up_pressed() -> void:
	health_bar.health += 1


func _on_health_down_pressed() -> void:
	health_bar.health -= 1
