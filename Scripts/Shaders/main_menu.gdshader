shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float scale = 1.5;
uniform float upward_speed = 0.05;
uniform float wave_amplitude = 0.05;
uniform float wave_frequency = 10.0;
uniform float shimmer_intensity = 0.05;
uniform float alpha = 0.3;

void fragment() {
    vec2 uv = UV * scale;

    // Add upward scroll
    uv.y -= TIME * upward_speed;

    // Add sine wave horizontal drift
    uv.x += sin(uv.y * wave_frequency + TIME) * wave_amplitude;

    // Colorized output from NoiseTexture2D + color_ramp
    vec3 color = texture(noise_texture, uv).rgb;

    COLOR = vec4(color, alpha);;
}
