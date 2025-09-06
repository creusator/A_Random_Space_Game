shader_type canvas_item;

uniform sampler2D noise_tex1: repeat_enable;
uniform sampler2D noise_tex2: repeat_enable;
uniform vec3 yellow_color: source_color;
uniform vec3 orange_color: source_color;
uniform vec3 smoke_color: source_color;
uniform float effect_speed = 1.8;
const float flame_width = 0.55;

uniform float flame_height = 1.0;

float ellipse(vec2 coord, float a, float b) {
	float x2 = pow(coord.x - 0.5, 2.0);
	float y2 = pow(coord.y + 0.6, 2.0);

	float val = x2/pow(a, 2.0) + y2/pow(b, 2.0);
	return val;
}

float soft_light(float base, float blend){
	float limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}

float get_flame_noise(vec2 uv) {
	float noise1 = texture(noise_tex1, vec2(uv.x, uv.y - TIME * effect_speed)).r;
	float noise2 = texture(noise_tex2, vec2(uv.x, uv.y - TIME * effect_speed)).r;
	float smoke = soft_light(noise1, noise2);
	return smoke;
}

void fragment() {
	float main_flame = ellipse(UV, flame_width, flame_height);
	float smoke_flame = ellipse(UV, flame_width, flame_height * 1.65);
	vec3 color = orange_color;
	float yellow_mix_factor = smoothstep(0.0, 0.4, 1.0 - main_flame);
	color =  mix(color, yellow_color, yellow_mix_factor);

	vec3 smoke = smoke_color * get_flame_noise(UV);
	float smoke_mix_factor = smoothstep(0.4, 1.2, 1.0 - UV.y);
	vec3 mixed_smoke = mix(smoke, color, smoke_mix_factor);

	COLOR.rgb = mixed_smoke;
	float main_flame_alpha = smoothstep(0.0, 0.8, 1.0 - main_flame);
	float smoke_flame_alpha = smoothstep(0.0, 6.0, 1.0 - smoke_flame);
	COLOR.a = main_flame_alpha + smoke_flame_alpha;
}
