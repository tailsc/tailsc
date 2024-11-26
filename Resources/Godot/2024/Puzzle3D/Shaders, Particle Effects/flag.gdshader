shader_type spatial;

uniform sampler2D uv_offset_texture ;
uniform vec2 uv_offset_scale = vec2(-0.2, -0.1);
uniform vec2 time_scale = vec2(0.1, 0.0);
uniform float face_distortion = 0.5;


void vertex(){
	
	vec2 base_uv_offset = UV * uv_offset_scale;
	base_uv_offset += TIME*time_scale;

	float noise = texture(uv_offset_texture, base_uv_offset).r;
	// Convert from 0.0 <=> 1.0 to -1.0 <=> 1.0
	float texture_based_offset = noise * 2.0 - 1.0;
	// Apply dampening
	texture_based_offset *= UV.x;

	VERTEX.y += texture_based_offset;
	// Distort the face to give impression of conserving shape
	VERTEX.z += texture_based_offset * face_distortion;
	VERTEX.x += texture_based_offset * -face_distortion;
}
void fragment() {
 	ALBEDO = vec3(0.8, 0.0, 0.0);
	ROUGHNESS = 0.5;
	METALLIC = 0.0;
	
	
}