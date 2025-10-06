shader_type canvas_item;

uniform vec3 key_color : source_color = vec3(0.0, 1.0, 0.0); // target color (green)
uniform float threshold : hint_range(0.0, 1.0) = 0.3;        // tolerance for color similarity
uniform float softness : hint_range(0.0, 1.0) = 0.1;          // smooth edge fade


uniform sampler2D gradient;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Difference between pixel and key color
    float diff = distance(tex_color.rgb, key_color);
    
    // Smooth step to soften edges
    float alpha = smoothstep(threshold, threshold + softness, diff);
    
	
	
	
	
    COLOR = vec4(tex_color.rgb, tex_color.a * alpha);
	
	
	float GrayValue = (COLOR.r + COLOR.g + COLOR.b)/3.0;
	COLOR = vec4(GrayValue,GrayValue,GrayValue,1.0);
	
	//2nd step: Swap palette
	vec2 new_uv = vec2(GrayValue);
	vec4 gradient_color = texture(gradient, new_uv);
	COLOR = vec4(gradient_color.rgb,1.0);
	
	//Erase the contour for png images
	vec4 textura = texture(TEXTURE,UV);
	COLOR.a = COLOR.a * textura.a * alpha;
	
	
}