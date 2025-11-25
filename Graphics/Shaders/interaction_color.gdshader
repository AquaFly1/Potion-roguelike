/*
Earthbound battle backgrounds shader with scrolling effect and palette cycling like in the original game.
@retr0_dev

Apply the shader to a TextureRect or a Sprite. Use a texture with some shapes in a transparent background for best results.
You can then use a ColorRect or another method to paint the background.
You can use the shader on multiple TextureRects and obtain a double-buffer effect tweaking the values for each one, remember to Make Unique the shader material.
*/
shader_type canvas_item;

uniform sampler2D uv_warp: filter_nearest, repeat_enable;
uniform sampler2D screen_texture: hint_screen_texture;
uniform float intensity: hint_range(0.0, 1.0);
uniform float speed: hint_range(0.0, 1.0);
uniform float warp_repeat: hint_range(0., 20.) = 1.;
uniform vec2 warp_offset;
uniform vec2 warp_scroll;

vec4 shift_hue(in vec4 color, in float shift) {
	// The unit gray vector in RGB color space.
	vec3 gray = vec3(0.57735);
	// Project color onto gray axis.
	vec3 projection = gray * dot(gray, color.rgb);
	// Vector from gray axis to original color.
	vec3 U = color.rgb - projection;
	// Vector perpendicular to gray axis and U.
	vec3 V = cross(gray, U);
	// Rotate U and V around the gray axis.
	vec3 shifted = U * cos(shift * 2.0 * PI) + V * sin(shift * 2.0 * PI) + projection;
	return vec4(shifted, color.a);
}


void fragment()
{
	vec4 warp =

		texture(uv_warp,mod(UV*warp_repeat +  warp_scroll*TIME + warp_offset,1.));

	COLOR = texture(screen_texture, UV + (UV-vec2(0.5,0.5))*(warp.b-.5) +
		(
			shift_hue(warp,TIME*speed)
				.rg
				-vec2(0.5,0.5)
			)*intensity
			
			);
}
