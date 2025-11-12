shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture,filter_nearest;
uniform float pixel_resolution : hint_range(10.0, 1080.0) = 240.0;

uniform int color_steps : hint_range(2, 64) = 16;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.1;
uniform bool enable_dither = true;
uniform float dither_strength : hint_range(0.0, 1.0) = 0.3;

const mat4 bayerIndex = mat4(
    vec4(00.0/16.0, 12.0/16.0, 03.0/16.0, 15.0/16.0),
    vec4(08.0/16.0, 04.0/16.0, 11.0/16.0, 07.0/16.0),
    vec4(02.0/16.0, 14.0/16.0, 01.0/16.0, 13.0/16.0),
    vec4(10.0/16.0, 06.0/16.0, 09.0/16.0, 05.0/16.0));

float random(vec2 co) {
	return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float ign(vec2 uv) {
    return fract(52.9829189 * fract(
		dot(uv, vec2(0.06711056,0.00583715))))-0.5;
}

float bayer_dither(vec2 pos) {
	int x = int(mod(pos.x, 4.0));
	int y = int(mod(pos.y, 4.0));
	int index = x + y * 4;

	float bayer[16] = float[](
		0.0, 8.0, 2.0, 10.0,
		12.0, 4.0, 14.0, 6.0,
		3.0, 11.0, 1.0, 9.0,
		15.0, 7.0, 13.0, 5.0
	);
	float bayerValue = bayerIndex[int(pos.x) % 4][int(pos.y) % 4];
	return bayer[index] / 16.0;
}



void fragment() {
	vec2 pixel_uv = vec2(
		floor((UV.x * (pixel_resolution + 1.0) - (UV.x - 0.5))*(16.0/9.0) )/ ((pixel_resolution + 1.0)*(16.0/9.0)),
		floor(UV.y * (pixel_resolution + 1.0) - (UV.y - 0.5))/ (pixel_resolution + 1.0)
		);
	//pixel_uv = round(UV*pixel_resolution)/pixel_resolution;
	vec2 pixel_frag = pixel_uv*vec2((16.0/9.0),1.0)*pixel_resolution;

	vec3 color = texture(screen_texture, pixel_uv).rgb;



	float steps = float(color_steps);
	color = color + ign(FRAGCOORD.xy)*0.02;
	color = floor(color * steps + 0.5) / steps;


	float noise = (random(UV + mod(TIME,2)) - 0.5) * noise_strength;
	color += noise;

	if (enable_dither) {
		float threshold = bayer_dither(pixel_frag);
		color += (dither_strength * (threshold - 0.5));
	}

	COLOR.rgb = clamp(color, 0.0, 1.0);
}
