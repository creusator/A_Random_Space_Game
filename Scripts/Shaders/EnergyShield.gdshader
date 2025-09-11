shader_type canvas_item;

uniform int shape_type = 0; // 0 = circle, 1 = capsule
uniform vec2 shape_size = vec2(100.0, 100.0);
uniform float radius = 50.0;
uniform vec4 color = vec4(0.0, 0.8, 1.0, 0.7);

uniform float line_thickness = 0.1;
uniform float smooth_factor = 4.0;
uniform float inner_shrink = 1.0;

float sd_circle(vec2 p, float r) {
	return length(p) - r;
}

float sd_roundrect(vec2 p, vec2 b, float r) {
	vec2 q = abs(p) - b;
	return length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - r;
}

void fragment() {
	vec2 center = vec2(0.5, 0.5);
	float maxdim = max(shape_size.x, shape_size.y);
	vec2 uv = (UV - center) * shape_size / maxdim;
	float sdf = 1.0;
	if (shape_type == 0) {
		float r = 0.48;
		sdf = sd_circle(uv, r);
	} else {
		float r_px = radius * 0.99;
		float half_h_px = max((shape_size.y * 0.49) - r_px, 0.0);
		float r_norm = r_px / maxdim;
		float half_h_norm = half_h_px / maxdim;
		sdf = sd_roundrect(uv, vec2(r_norm, half_h_norm), r_norm);
	}
	float inside = 1.0 - smoothstep(0.0, smooth_factor / maxdim, sdf);
	float t_norm = line_thickness / maxdim;
	float s_norm = smooth_factor / maxdim;
	float outline = 1.0 - smoothstep(t_norm, t_norm + s_norm, abs(sdf));
	float inner = 0.0;
	if (shape_type == 0) {
		float r_in = 0.5 * inner_shrink;
		float sdf_in = sd_circle(uv, r_in);
		inner = 1.0 - smoothstep(-s_norm, s_norm, sdf_in);
	} else {
		float r_px = radius;
		float half_h_px = max((shape_size.y * 0.5) - r_px, 0.0);
		float r_norm = r_px / maxdim;
		float half_h_norm = half_h_px / maxdim;
		vec2 b_in = vec2(r_norm * inner_shrink, half_h_norm * inner_shrink);
		float r_in_norm = r_norm * inner_shrink;
		float sdf_in = sd_roundrect(uv, b_in, r_in_norm);
		inner = 1.0 - smoothstep(-s_norm, s_norm, sdf_in);
	}
	float alpha = clamp((outline + (inside - inner)), 0.0, 1.0);
	COLOR = color;
	COLOR.a *= alpha;
}
