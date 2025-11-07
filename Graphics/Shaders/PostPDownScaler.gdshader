shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture,filter_nearest;
uniform float pixel_resolution : hint_range(64.0, 1080.0) = 240.0;

uniform bool enable_vintage = true;
uniform float vintage_strength : hint_range(0.0, 1.0) = 0.8;

uniform bool enable_glow = true;
uniform float glow_strength : hint_range(0.0, 1.0) = 0.4;
uniform float glow_spread : hint_range(0.001, 0.01) = 0.005;

vec3 get_glow(vec2 uv) {
	vec3 col = vec3(0.0);
	float total = 0.0;

	for (int x = -1; x <= 1; x++) {
		for (int y = -1; y <= 1; y++) {
			vec2 offset = vec2(float(x), float(y)) * glow_spread;
			col += texture(screen_texture, uv + offset).rgb;
			total += 1.0;
		}
	}
	return col / total;
}

vec3 apply_black_vintage_edges(vec3 color, vec2 uv) {
	// Distance from screen center
	float dist = distance(uv, vec2(0.5));

	// Mask: only affects edges
	float edge_mask = smoothstep(0.4, 0.8, dist);

	// Blend edges to black
	color = mix(color, vec3(0.0), edge_mask * vintage_strength);

	return color;
}



void fragment() {
	vec3 color = texture(screen_texture, UV).rgb;
	if (enable_glow) {
		vec3 blurred = get_glow(UV);
		color += blurred * glow_strength;
	}

	if (enable_vintage) {
		color = apply_black_vintage_edges(color, UV);
	}

	COLOR.rgb = clamp(color, 0.0, 1.0);

}