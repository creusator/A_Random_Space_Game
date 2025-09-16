shader_type canvas_item;

uniform vec4 highlighted_color1 : source_color;
uniform vec4 new_highlighted_color1 : source_color;
uniform vec4 highlighted_color2 : source_color;
uniform vec4 new_highlighted_color2 : source_color;
uniform vec4 highlighted_color3 : source_color;
uniform vec4 new_highlighted_color3 : source_color;
uniform float intensity : hint_range(0.0, 1.0, 0.01);
uniform float change_per_second : hint_range(0.0, 5.0, 0.25);
uniform bool is_active;
uniform bool pulse_mode;
uniform bool random_mode;

float rand(float n) {
	return fract(sin(n) * 43758.5453123);
}

void fragment() {
	vec4 currentColor = texture(TEXTURE, UV);
	if (is_active == true) {
		float fade_effect = 0.0;
		float fade_effect2 = 0.0;
		float fade_effect3 = 0.0;
		if (pulse_mode == true) {
			fade_effect = (sin(TIME) * 0.5 + 0.5) * intensity;
			fade_effect2 = (sin(TIME - 3.0) * 0.5 + 0.5) * intensity;
			fade_effect2 = (sin(TIME - 5.0) * 0.5 + 0.5) * intensity;
		}
		else if (random_mode == true) {
			fade_effect = rand(floor(TIME * change_per_second)) * intensity;
			fade_effect2 = rand(floor(TIME * change_per_second)) * intensity;
			fade_effect3 = rand(floor(TIME * change_per_second)) * intensity;
		}
		if (currentColor == highlighted_color1) {
			COLOR = mix(highlighted_color1, new_highlighted_color1, fade_effect);
		}
		else if (currentColor == highlighted_color2) {
			COLOR = mix(highlighted_color2, new_highlighted_color2, fade_effect2);
		}
		else if (currentColor == highlighted_color3) {
			COLOR = mix(highlighted_color3, new_highlighted_color3, fade_effect3);
		}
		else {
			COLOR = currentColor;
		}
	}
	else {
		COLOR = currentColor;
	}
}
