extends PathFollow2D
@export var path_Pos_Index = 0
var progress_ratio_change_check = 0.0
var previous_progress_ratio = 0.0
var time = 0.0

func _ready() -> void:
	cubic_interp = true


func _process(_delta: float) -> void:
	if progress_ratio_change_check != progress_ratio:
		time = 0
		previous_progress_ratio = progress_ratio
	if time !=1:
		time = clamp(time+0.5,0,1)
	progress_ratio = lerp(previous_progress_ratio,float((path_Pos_Index-1))/4, time)
	
	progress_ratio_change_check = progress_ratio
