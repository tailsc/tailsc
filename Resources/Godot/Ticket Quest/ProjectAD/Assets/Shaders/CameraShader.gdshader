shader_type spatial;

uniform vec3 outline_color;
uniform float outline_width;

void fragment() {
    // Calculate the dot product of the fragment's normal and light direction
    float light = dot(normalize(NORMAL), vec3(0.0, 1.0, 0.0));

    // Determine the number of cel shading steps
    float steps = 4.0; // Adjust this value to control the number of shading steps

    // Calculate the cel shading value based on the number of steps
    float cel = floor(light * steps) / steps;

    // Calculate the outline
    float outline = 1.0 - smoothstep(1.0 - outline_width, 1.0, cel);

    // Combine the cel shading color and outline color
    vec3 final_color = mix(outline_color, vec3(cel), outline);

    // Output the final color
    ALBEDO = final_color;
}
