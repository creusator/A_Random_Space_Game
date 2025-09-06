shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec3 target_color: source_color;
render_mode blend_add;

float ellipse(vec2 coord, float a, float b) {
	float x2 = pow(coord.x - 0.5, 2.0);
	float y2 = pow(coord.y - 0.5, 2.0);

	float val = x2/pow(a, 2.0) + y2/pow(b, 2.0);
	return val;
}

void fragment() {
	float inner_glow_area = 1.0 - smoothstep(0.0, 0.8, ellipse(UV, 0.28, 0.6));
	vec3 tex_color = texture(screen_texture, SCREEN_UV).rgb;
	float d = smoothstep(0.0, 0.5, distance(target_color, tex_color));
	if(d < 1.0) {
		COLOR.rgb = tex_color * 3.0;
	} else {
		COLOR.rgb = inner_glow_area * tex_color * 2.0;
	}

}