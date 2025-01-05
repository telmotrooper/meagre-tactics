shader_type spatial;

uniform vec3 tint_color: source_color = vec3(1.0,1.0,1.0);
uniform float strength = 0.5;

void fragment() {
	ALBEDO = tint_color;
	ALPHA = strength;
}
