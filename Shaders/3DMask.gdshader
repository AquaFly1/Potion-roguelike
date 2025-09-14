shader_type canvas_item;

uniform vec3 key_color : source_color = vec3(0.0, 1.0, 0.0); // target color (green)
uniform float threshold : hint_range(0.0, 1.0) = 0.3;        // tolerance for color similarity
uniform float softness : hint_range(0.0, 1.0) = 0.1;          // smooth edge fade

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Difference between pixel and key color
    float diff = distance(tex_color.rgb, key_color);
    
    // Smooth step to soften edges
    float alpha = smoothstep(threshold, threshold + softness, diff);
    
    COLOR = vec4(tex_color.rgb, tex_color.a * alpha);
}