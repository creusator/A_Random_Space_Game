shader_type canvas_item;

uniform vec4 highlighted_color1 : source_color;
uniform vec4 new_highlighted_color1: source_color;
uniform vec4 highlighted_color2 : source_color;
uniform vec4 new_highlighted_color2: source_color;
uniform float intensity : hint_range(0.0, 1.0, 0.01);
uniform bool is_active;
uniform bool pulse_mode;
uniform bool random_mode;

void fragment(){
	vec4 currentColor = texture(TEXTURE, UV);
	if (is_active == true) {
		if (pulse_mode == true) {
			float fade_effect = sin(TIME) * intensity;
			float fade_effect2 = sin(TIME - 3.0) * intensity;
		}
		else if (random_mode == true) {
			float fade_effect = 0.0;
			float fade_effect2 = 0.0;
		}
		if (currentColor == highlighted_color1)
		{
			COLOR = new_highlighted_color1 - fade_effect;
		}
		else if (currentColor == highlighted_color2)
		{
			COLOR = new_highlighted_color2 - fade_effect2;
		}
		else
		{
			COLOR = currentColor;
		}
		
	}
}