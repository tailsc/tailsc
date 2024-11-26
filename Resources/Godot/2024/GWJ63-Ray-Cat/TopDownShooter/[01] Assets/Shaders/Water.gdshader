shader_type spatial;
render_mode unshaded;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform vec4 main_color : source_color;
uniform vec4 intersection_color : source_color;
uniform float intersection_max_threshold = 0.5;
uniform sampler2D displ_tex : hint_default_white;
uniform float displ_amount = 0.6;
uniform float near = 0.15;
uniform float far = 300.0;

float linearize(float c_depth) {
    c_depth = 2.0 * c_depth - 1.0;
    return near * far / (far + c_depth * (near - far));
}

void fragment() {
    float zdepth = linearize(texture(DEPTH_TEXTURE, SCREEN_UV).x);
    float zpos = linearize(FRAGCOORD.z);
    float diff = zdepth - zpos;

    vec2 displ = texture(displ_tex, UV - TIME / 7.0).rg;
    displ = ((displ * 2.0) - 1.0) * displ_amount;
    diff += displ.x;

    vec4 col = mix(intersection_color, main_color, step(intersection_max_threshold, diff));
    ALBEDO = col.rgb;
}