shader_type spatial;

render_mode unshaded;
render_mode depth_draw_never,depth_test_disabled;

uniform float energy : hint_range(0.0, 10.0) = 4.0;
uniform vec4 color : source_color = vec4(1.0, 0.2, 0.0, 1.0);
uniform vec4 hole_color : source_color = vec4(0,0,0,1);
uniform float rim : hint_range(0.0,1.0) = 0.1;
uniform float proximity_fade : hint_range(0.0, 4.0) = 0.3;

group_uniforms Dimensions;
uniform float accretion_radius_inner : hint_range(0.0, 10.0) = 1.0;
uniform float accretion_radius_outer : hint_range(3.0, 10.0) = 7.0;
uniform float lensing_radius : hint_range(0.0, 1.0) = 0.2;
uniform float lensing_falloff : hint_range(1.0, 5.0) = 1.0;
uniform float lensing_strength : hint_range(0.5, 2.0) = 1.0;
group_uniforms Texture;

uniform sampler2D accretion_disk;// : repeat_disable;
uniform sampler2D errosion_ramp : hint_default_black;
uniform vec2 uv_mul = vec2(1,1);
uniform vec2 uv_add = vec2(0,0);

#define USE_SCREEN_TEXTURES

#ifdef USE_SCREEN_TEXTURES
uniform sampler2D screen_tex : hint_screen_texture, repeat_disable;
uniform sampler2D depth_tex : hint_depth_texture, repeat_disable;
#endif

vec2 cartesianToPolar(vec2 p){
	return vec2(length(p), atan(p.y,p.x));
}
vec2 cartesianToPolarUV(vec2 p){
	return cartesianToPolar(p)/vec2(1,TAU) + vec2(0,0.5);
}
vec4 texturePolar(sampler2D tex, vec2 polar_uv){ // given
	// Rotate by 180 degrees. This won't change the derivative, but moves the discontinuity to the opposite side.
	vec2 p1 = vec2(polar_uv.x,fract(polar_uv.y-0.5));
	vec2 p0 = polar_uv;
	
	vec2 dx = dFdx(p0);
	vec2 dy = dFdy(p0);
	
	// Patch up the partial derivatives on the left half
	if(abs(polar_uv.y-0.5) > 0.25){
		dx = dFdx(p1);
		dy = dFdy(p1);
	}

	return textureGrad(tex,polar_uv,dx,dy);
}

// plane defined by p (p.xyz must be normalized)
float planeIntersect( in vec3 ro, in vec3 rd, in vec4 p )
{
    return -(dot(ro,p.xyz)+p.w)/dot(rd,p.xyz);
}

// sphere of size ra centered at point ce
vec2 sphIntersect( in vec3 ro, in vec3 rd, in vec3 ce, float ra )
{
    vec3 oc = ro - ce;
    float b = dot( oc, rd );
    vec3 qc = oc - b*rd;
    float h = ra*ra - dot( qc, qc );
    if( h<0.0 ) return vec2(-1.0); // no intersection
    h = sqrt( h );
    return vec2( -b-h, -b+h );
}

mat3 rotationAxisAngle( const vec3 v, float a )
{
	a = -a;
    float si = sin( a );
    float co = cos( a );
    float ic = 1.0f - co;

    return mat3( vec3(v.x*v.x*ic + co,       v.y*v.x*ic - si*v.z,    v.z*v.x*ic + si*v.y),
                 vec3(v.x*v.y*ic + si*v.z,   v.y*v.y*ic + co,        v.z*v.y*ic - si*v.x),
                 vec3(v.x*v.z*ic - si*v.y,   v.y*v.z*ic + si*v.x,    v.z*v.z*ic + co) );
}

float box(vec2 p, vec2 d){
	p = abs(p) - d;
	return max(p.x,p.y);
}

float EventHorizon(vec3 ro, vec3 rd){
	float t = atan(length(cross(normalize(-ro),rd)),dot(normalize(-ro),rd));
	float r = mix(0.0, PI/2.0, 1.0/length(ro));
	return t/r - 1.0;
}

float proximityFade(mat4 clipToModel, vec3 ro, vec2 uv, float scene_depth, vec3 model_pos){
	vec4 scene_pos = clipToModel * vec4(uv*2.0-1.0,scene_depth,1); scene_pos.xyz /= scene_pos.w;
	return length(scene_pos.xyz - ro) - length(model_pos - ro);
}

float intersectAccretionDisk(vec3 ro, vec3 rd){
	float d = EventHorizon(ro, rd);
	
	float distortion = rd.y - normalize(-ro).y;
	distortion = lensing_strength * exp(-pow(max(d,0.0), lensing_falloff) / lensing_radius) * smoothstep(-0.0, 0.01, distortion);
	
	
	mat3 rotator = rotationAxisAngle(normalize(cross(rd,vec3(0,1,0))), distortion * PI/2.0);
	
	ro *= rotator;
	rd *= rotator;
	
	if(rd.y > 0.0) return -1.0;
	
	return planeIntersect(ro,rd,vec4(0,1,0,0));
}

vec2 screenDisplacement(mat4 clipToView, vec2 screen_uv, vec2 displacement){
	// Should adjust for aspect ratio and fov
	//float aspect = length(clipToView[1].xy) / length(clipToView[0].xy);
	//displacement.x /= aspect;
	//displacement = (mat2(clipToView)) * displacement;
	
	return screen_uv + displacement;
}

// alpha blend over operator
void over(inout vec3 RGB, inout float A, vec4 col){
	RGB.xyz *= A;
	col.xyz *= col.w;
	
	RGB = col.xyz + RGB * (1.0 - col.a);
	A = col.a + A * (1.0 - col.a);
	
	if(A > 0.0) {
		RGB /= A;
	}
}

varying mat4 inv_modelview;
void vertex(){
	inv_modelview = inverse(VIEW_MATRIX * MODEL_MATRIX);
	VERTEX *= accretion_radius_outer;
}

void fragment() {
	// construct the ray in view space
	vec3 rd = -VIEW;
	vec3 ro = VERTEX - rd * VERTEX.z/rd.z;

	// transform ray to model space
	ro = (inv_modelview * vec4(ro,1)).xyz;
	rd = normalize( mat3(inv_modelview) * rd );
	
	float d = EventHorizon(ro, rd);
	
	vec2 sphere_ts = sphIntersect(ro,rd,vec3(0),2.0);
	
	float sphere_t = sphere_ts.x;
	if(sphere_t < 0.0){
		sphere_t = sphere_ts.y;
		if(sphere_t < 0.0){
			sphere_t = accretion_radius_outer;
		}
	}
	
	vec3 sphere_p = ro + rd * sphere_t;
	
	float displacement = lensing_strength * min(exp(-d/lensing_radius),1.0);
	
	vec2 displaced_uv = screenDisplacement(PROJECTION_MATRIX, SCREEN_UV, vec2(1) * displacement);
	//displaced_uv = SCREEN_UV + displacement;
	
	ALBEDO = texture(screen_tex, SCREEN_UV + displacement).rgb * smoothstep(-0.1, 0.2, -box(displaced_uv - vec2(0.5),vec2(0.5)) );
	
	float scene_depth = texture(depth_tex, SCREEN_UV).x;
	
	float fade = smoothstep(0.0, proximity_fade, proximityFade(inv_modelview * INV_PROJECTION_MATRIX,ro,SCREEN_UV,scene_depth,sphere_p));
	
	// Some rim glow to complement the accretion disk
	ALBEDO += energy * color.a * color.rgb * min(exp(-d / rim * 10.0),1.0);
	
	ALPHA = 1.0;
	ALPHA *= smoothstep(0.0,.002,displacement);
	
	ALPHA *= fade;
	
	// The hole
	ALBEDO = mix(ALBEDO, hole_color.rgb, 1.0-clamp(d/fwidth(d), 0.0, 1.0));
	
	// Accretion disk (both sides)
	float s = sign(ro.y);
	
	ro.y *= s;
	rd.y *= s;
	
	for(int i = 0; i<2; i++){
		ro.y *= -1.0;
		rd.y *= -1.0;
		
		float t = intersectAccretionDisk(ro,rd);
		vec3 p = ro + rd * t;
		
		vec2 uv = cartesianToPolarUV(p.xz);
		uv.x = (uv.x - accretion_radius_inner) / (accretion_radius_outer - accretion_radius_inner);
		
		vec2 accretion_uv = uv * uv_mul + uv_add;
		vec4 samp = texturePolar(accretion_disk, accretion_uv);
		samp.rgb = smoothstep(0.0, 1.0, samp.rgb - texturePolar(errosion_ramp, uv.xy).x);
		
		if(t>0.0) {
			fade = smoothstep(0.0,0.5,0.5-abs(uv.x-0.5));
			fade *= smoothstep(0.0, proximity_fade, proximityFade(inv_modelview * INV_PROJECTION_MATRIX,ro,SCREEN_UV,scene_depth,p));
			
			// Camera fade
			fade *= smoothstep(0.0, proximity_fade, length(p - ro));
			
			if(i == 0) {
				fade *= step(0.0,d);
			}
			
			//ALBEDO = mix(ALBEDO, energy * color.rgb, samp.x * fade);
			//ALPHA = mix(ALPHA, 1.0, samp.x * fade);
			
			over(ALBEDO, ALPHA, vec4(energy * color.rgb, color.a * samp.x * fade));
		}
	}
}