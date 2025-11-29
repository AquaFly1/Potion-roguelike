shader_type spatial;

render_mode unshaded,blend_mix,cull_disabled;
uniform sampler2D sprite_texture : source_color, filter_nearest;
uniform vec3 hot_color: source_color;
uniform vec3 cool_color: source_color;
uniform sampler2D noise: source_color, filter_nearest;
uniform float alpha_steps: hint_range(1.0, 5., 1) = 1.0;
uniform float intensity: hint_range(0.0, 1.0);
uniform float lighten: hint_range(0.0, 1.0, 0.1);
uniform vec2 scroll = vec2(0.,0.);
uniform bool billboard = true;

void vertex() {
	if (billboard){
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
}


float degrade_alpha(vec2 uv,vec2 stp)
{
	int size = 9;
	float alph = .0;
	for (int i = 0; i < int(pow(float(size),2.)); i++){
		alph += texture(sprite_texture,
						uv
							+vec2
							(
								float(i%size-(size-1)/2),
								float((i - i%size)/size - (size-1)/2)
							)
						* stp
						)
				.a 
		/ 80.;
	}
	
	return min(alph,1.0);
}

void fragment() {
	ALPHA = 0.;
	if (intensity > 0.){
	vec2 stp = vec2(1,1)/ vec2(textureSize(sprite_texture,0));
	vec4 col = texture(sprite_texture,UV);
	//float burn_alpha = clamp(min(texture(sprite_texture,UV+vec2(0.0,1.0)*0.03).a , 1.0) - col.a,0.0,1.0);
	vec4 degrade = vec4(1,1,1,degrade_alpha(UV,stp)); 
	
	degrade.a = 1.-degrade.a;
	
	vec4 burn = degrade;
	burn.a =	
				(degrade.a * col.a + 0.05)
				*
				clamp(	max((texture(noise,floor(UV /stp) * stp.y + TIME*scroll).r),0.0)
					
						,.0,2.)
				;
	
	
	burn.rgb = 1. * mix(cool_color,min(hot_color*(max(1.0,1.+sin(TIME)*0.2+0.2)),vec3(0.7,0.7,0.7)),(burn.a*10.)*intensity/2.0-0.2);
	
	burn.a = max(burn.a * (0.72+intensity) + (1. + round(degrade.a+0.1)) * intensity/2.0,0.0);
	
	float alpha_stepped = 0.;
	for (float j = 0.; j < alpha_steps; j++)
	{
		alpha_stepped *= (1.-1./(j+1.));
		alpha_stepped += round(burn.a + j*0.3/alpha_steps)/(j+1.);
	}
	
	ALBEDO =	burn.rgb * (1.+lighten*2.);
	
	ALPHA = col.a* min(alpha_stepped ,1.0)*(1.-lighten/2.);
	
	
	//ALPHA = (round(burn.a-0.2) + round(burn.a-0.5) ) /2.;
	
	}
	
	
	// Called for every pixel the material is visible on.
}

