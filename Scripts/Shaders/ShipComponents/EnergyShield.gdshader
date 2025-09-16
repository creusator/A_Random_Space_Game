shader_type canvas_item;

uniform int shape_type = 0; // 0 = circle, 1 = capsule
uniform vec2 shape_size = vec2(100.0, 100.0);
uniform float radius = 50.0;
uniform vec4 color : source_color = vec4(1.0);

uniform float line_thickness = 0.1;
uniform float smooth_factor = 4.0;
uniform float inner_shrink = 1.0;
uniform float corner_radius_factor = 100.0;

float sd_circle(vec2 p, float r) {
	return length(p) - r;
}

float sd_roundrect(vec2 p, vec2 b, float r) {
	vec2 q = abs(p) - b;
	return length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - r;
}

float sd_roundrect_custom(vec2 p, float half_w_norm, float half_h_norm, float corner_r_norm) {
	float rect_half_x = max(half_w_norm - corner_r_norm, 0.0);
	vec2 b = vec2(rect_half_x, half_h_norm);
	vec2 q = abs(p) - b;
	return length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - corner_r_norm;
}

void fragment() {
	vec2 center = vec2(0.5, 0.5);
	float maxdim = max(shape_size.x, shape_size.y);
	vec2 uv = (UV - center) * shape_size * 1.1 / maxdim;
	float sdf = 1.0;

	if (shape_type == 0) {
		float r = 0.49;
		sdf = sd_circle(uv, r);
	} else {
		float half_w_px = shape_size.x * 0.49;
		float corner_px = clamp(radius * corner_radius_factor, 0.0, half_w_px);
		float half_h_px = max((shape_size.y * 0.49) - corner_px, 0.0);
		float half_w_norm = half_w_px / maxdim;
		float half_h_norm = half_h_px / maxdim;
		float corner_r_norm = corner_px / maxdim;
		sdf = sd_roundrect_custom(uv, half_w_norm, half_h_norm, corner_r_norm);
	}
	float inside = 1.0 - smoothstep(0.0, smooth_factor / maxdim, sdf);
	float t_norm = line_thickness / maxdim;
	float s_norm = smooth_factor / maxdim;
	float outline = 1.0 - smoothstep(t_norm, t_norm + s_norm, abs(sdf));
	float inner = 0.0;
	if (shape_type == 0) {
		float r_in = 0.49 * inner_shrink;
		float sdf_in = sd_circle(uv, r_in);
		inner = 1.0 - smoothstep(-s_norm, s_norm, sdf_in);
	} else {
		float half_w_px = shape_size.x * 0.5;
		float corner_px = clamp(radius * corner_radius_factor, 0.0, half_w_px);
		float corner_px_in = corner_px * inner_shrink;
		float half_h_px = max((shape_size.y * 0.5) - corner_px, 0.0);
		float half_h_px_in = half_h_px * inner_shrink;
		float half_w_norm_in = half_w_px / maxdim;
		float half_h_norm_in = half_h_px_in / maxdim;
		float corner_r_norm_in = corner_px_in / maxdim;
		float sdf_in = sd_roundrect_custom(uv, half_w_norm_in, half_h_norm_in, corner_r_norm_in);
		inner = 1.0 - smoothstep(-s_norm, s_norm, sdf_in);
	}
	float alpha = clamp((outline + (inside - inner)), 0.0, 1.0);
	COLOR = color;
	COLOR.a *= alpha;
}
