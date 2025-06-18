shader_type spatial;
render_mode unshaded, depth_prepass_alpha, cull_disabled;

uniform sampler2D noise_texture;
uniform float threshold : hint_range(0.0, 1.0) = 0.5;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;
uniform float edge_fade : hint_range(0.0, 1.0) = 0.2;
uniform vec4 puddle_color : source_color = vec4(0.1, 0.1, 0.2, 1.0);

void fragment() {
    vec2 uv = UV;
    float noise = texture(noise_texture, uv).r;

    // Radial falloff from center (fade to 0 at edges)
    vec2 radial_uv = uv * 2.0 - 1.0; // convert to range -1 to 1
    float dist = length(radial_uv); // distance from center
    float edge_mask = smoothstep(1.0 - edge_fade, 1.0, dist);

    // Combine noise-based shape with radial edge fade
    float shape = smoothstep(threshold + 0.05, threshold - 0.05, noise);
    float alpha = shape * (1.0 - edge_mask) * opacity;

    ALBEDO = puddle_color.rgb;
    ALPHA = alpha;
}