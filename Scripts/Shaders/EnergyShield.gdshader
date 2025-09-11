shader_type canvas_item;

uniform vec2 shape_size = vec2(100.0, 100.0);
uniform vec4 color = vec4(0.0, 1.0, 1.0, 1.0);

float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, length(position));
}

void fragment() {
	vec2 center = vec2(0.5, 0.5);
	vec2 uv = (UV - center) * shape_size / max(shape_size.x, shape_size.y);
	float radius = 0.49;
	float outer = circle(uv, radius, 0.01);
	float fade_effect = sin(TIME) * 0.02;
	float inner = 1.0 - circle(uv, radius * 0.8, 0.25 - fade_effect);
	COLOR = color;
	COLOR.a -= outer + inner;
}
