shader_type spatial;

uniform sampler2D height_map;
uniform float height_ratio = 1.0;

void vertex() {
	VERTEX.y = texture(height_map,UV).r * height_ratio;
}
