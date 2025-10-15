#define FLT_MAX 3.402823466e+38

shader_type canvas_item;
render_mode unshaded;

// Annoyingly, since this is set at compile, it seems you need to manually
// set this array size to match the number of colors in your array. Otherwise
// it will disregard the 'extra' colors
uniform vec4[100] colors : source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

const vec3 D65_WHITE = vec3(0.95045592705, 1.0, 1.08905775076);
const vec3 WHITE = D65_WHITE;

uniform vec4 colorForDelete: source_color;

// RGB to LAB implementation from
// https://github.com/sv3/gift/blob/master/RGB2Lab.glsl

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV).rgba;
	float min_dist = FLT_MAX;
	for(int i=0;i<colors.length(); i++) {
		float dist = distance(
			color,
			colors[i]
		);
		if (dist < min_dist) {
			min_dist = dist;
			COLOR = colors[i];
		}
	}
	COLOR.a = color.a;
	if (COLOR == colorForDelete) {
        COLOR.a = 0.0;
    }

}