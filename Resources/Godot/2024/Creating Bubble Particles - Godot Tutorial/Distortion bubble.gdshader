// Available at: https://godotshaders.com/shader/distortion-bubble/

shader_type spatial;

render_mode unshaded;

// fragment uniforms
uniform float distortionView : hint_range(0.0, 0.3, 0.005) = 0.03;
uniform float speedView : hint_range(0.0, 1.0, 0.005) = 0.5;
uniform sampler2D noiseViewX;
uniform sampler2D noiseViewY;
uniform sampler2D screenTexture : hint_screen_texture;
uniform vec3 tintColor : source_color;
uniform float fesnelAmount : hint_range(0.0, 5.0, 0.1);

// vertex uniforms
uniform float distortionVertex : hint_range(0.0, 0.3, 0.005) = 0.03;
uniform float speedVertex : hint_range(0.0, 1.0, 0.005) = 0.1;
uniform sampler2D noiseVertex;


float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void vertex()
{
	float noiseVal = (texture(noiseVertex, UV + (TIME * speedVertex)).r * 2.0) - 1.0; // Range: -1.0 to 1.0
	vec3 displacement = NORMAL * noiseVal * distortionVertex;
	VERTEX = VERTEX + displacement;
}

void fragment() 
{
	float noiseValueX  = (texture(noiseViewX, UV + (TIME * speedView)).r * 2.0) - 1.0; // Range: -1.0 to 1.0
	float noiseValueY  = (texture(noiseViewY, UV + (TIME * speedView)).r * 2.0) - 1.0; // Range: -1.0 to 1.0
	vec2 noiseDistort = vec2(noiseValueX, noiseValueY) * distortionView;
	vec3 distortedScreenTexture = vec3(texture(screenTexture, SCREEN_UV + noiseDistort).rgb);
	vec3 fesnelTint = (tintColor * fresnel(fesnelAmount, NORMAL, VIEW));
	
	ALBEDO = distortedScreenTexture + fesnelTint;
}