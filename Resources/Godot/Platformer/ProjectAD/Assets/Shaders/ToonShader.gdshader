shader_type spatial;
render_mode unshaded, cull_front;

uniform bool enable = true;
uniform float outline_thickness = 0.01;
uniform vec4 color : source_color  = vec4(0.0);


void vertex() {
	if (enable) {
		VERTEX += normalize(VERTEX) * outline_thickness;
	}
}

void fragment() {
	if (enable) {
		ALBEDO = color.rgb;
	}
}