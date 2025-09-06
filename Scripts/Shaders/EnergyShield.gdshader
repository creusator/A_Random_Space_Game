shader_type canvas_item;

uniform vec2 shape_size = vec2(100, 100);
uniform vec4 color= vec4(1.0,1.0,1.0,1.0);

float circle(vec2 position, float radius, float feather)
{
return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}

void fragment(){

float outer = circle(vec2(UV.x, UV.y), 0.35, 0.01);

float fade_effect = sin(TIME) * 0.02;

float inner = 1.0 - circle(vec2(UV.x, UV.y), 0.275, 0.15 - fade_effect);

COLOR = color;
COLOR.a -= outer + inner;

}