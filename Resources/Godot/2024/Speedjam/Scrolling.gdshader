shader_type canvas_item;

uniform sampler2D pattern_sampler : repeat_enable, filter_linear_mipmap;
uniform vec3 Top_Color : source_color; // Color at position 0
uniform vec3 Mid_Color : source_color; // Color at position 0.5
uniform vec3 Bot_Color : source_color; // Color at position 1
uniform vec3 pattern_color : source_color;
uniform float scale = 2.0;
uniform float ratio = 1.0;

void fragment() {
    // Calculate the vertical position of the fragment
    float gradient_position = UV.y;

    // Define positions for each color stop
    float position1 = 0.0;
    float position2 = 0.5;
    float position3 = 1.0;

    // Interpolate between colors based on position
    vec3 bg_color;
    if (gradient_position < position2) {
        bg_color = mix(Top_Color, Mid_Color, gradient_position / position2);
    } else {
        bg_color = mix(Mid_Color, Bot_Color, (gradient_position - position2) / (position3 - position2));
    }

    // Apply the pattern color as before
    COLOR.rgb = mix(pattern_color, bg_color, texture(pattern_sampler, UV * vec2(1.0, ratio) * scale + TIME * 0.025).x);
}
