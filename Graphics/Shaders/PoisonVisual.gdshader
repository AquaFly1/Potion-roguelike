shader_type canvas_item;

uniform sampler2D noise_tex : repeat_enable, filter_nearest;


void vertex() {
	
}

void fragment() {
	COLOR = texture(noise_tex,UV);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
