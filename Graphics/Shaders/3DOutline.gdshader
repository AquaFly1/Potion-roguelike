shader_type spatial;
render_mode unshaded,blend_mix,depth_prepass_alpha,cull_disabled,specular_disabled;
uniform sampler2D sprite_texture : source_color, filter_nearest;
uniform bool billboard = true;
uniform bool hovering = false;
uniform bool selected = false;
uniform bool flashing = false;
uniform float hovering_time_offset = 0.;
uniform vec4 line_color : source_color = vec4(1.0,1.0,1.0,1.0); // Glow or outline color
uniform float opacity: hint_range(0.0, 1.0) = 1;
//Goes through every single pixle and does thing

void vertex() {
	if (billboard){
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
}


void fragment() {
	vec4 col = texture(sprite_texture, UV); // Gets color at uv position of pixel

	// Sets source image as default pixel
	ALBEDO = col.rgb;
	ALPHA = col.a;

	vec2 pixel_size = 1.0 / vec2(textureSize(sprite_texture, 0)); // Set pixel size
	float alph = 0.0; // Start with a 0 alpha to add to with each check
	for (int i = 0; i < 4; i++) { // Goes around in a circle
		for (int j = 0; j < 1; j++) { // Extends out
			float radians360 = 6.28;
			// The angle from which to grab pixel information
			float angle = (radians360 / 4.)*float(i+1);
			// The distance to reach to grab pixel information
			float dist = float(j + 1);
			// Pixel coordinate to grab
			vec2 pixel_coor = vec2( sin(angle) , cos(angle) );
			// Gets the pixel based on the previous information
    		vec4 tex = texture(sprite_texture, UV + pixel_coor * pixel_size * dist);

			// Sharpness. If you don't care about this, enable the next line and delete the next 3
			alph = clamp(alph+tex.a*10.0,0.0,1.0);
		}
	}

	// Adds outline if this part of the image is transparent

	ALBEDO = line_color.rgb;
	ALPHA = clamp(alph*opacity,0,1) - col.a;
	if (selected)
	{
		ALBEDO = vec3(1.,1.,1.);
		ALPHA = alph-col.a;
	}
	if (hovering)
	{
		ALPHA = ALPHA + (alph-col.a*0.95) * (sin((TIME-hovering_time_offset+0.5)*5.)*float(hovering)*0.3+0.4);
	}


	ALPHA = clamp(ALPHA,0,2);

	// Enabling this line will cut out the image and leave the outline
	//ALPHA = max(ALPHA-col.a,0);
	// if you set blend to add, and set this as a second pass, you'll get a better glow effect
}