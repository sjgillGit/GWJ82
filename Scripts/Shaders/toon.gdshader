shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform int colors_per_channel : hint_range(2, 64) = 4;
uniform float dither_strength : hint_range(0.0, 1.0) = 0.25;
uniform bool use_dithering = true;

float bayer_dither_4x4(vec2 pos) {
	int x = int(mod(pos.x, 4.0));
	int y = int(mod(pos.y, 4.0));
	
	// 4x4 bayer matrix (values from 0 to 15)
	int index = int(
		(x == 0 && y == 0) ? 0 :
        (x == 1 && y == 0) ? 8 :
        (x == 2 && y == 0) ? 2 :
        (x == 3 && y == 0) ? 10 :
        (x == 0 && y == 1) ? 12 :
        (x == 1 && y == 1) ? 4 :
        (x == 2 && y == 1) ? 14 :
        (x == 3 && y == 1) ? 6 :
        (x == 0 && y == 2) ? 3 :
        (x == 1 && y == 2) ? 11 :
        (x == 2 && y == 2) ? 1 :
        (x == 3 && y == 2) ? 9 :
        (x == 0 && y == 3) ? 15 :
        (x == 1 && y == 3) ? 7 :
        (x == 2 && y == 3) ? 13 :
        5 // (x == 3 && y == 3)
	);
	
	return float(index) / 16.0;
}


void fragment() {
	// Get current color of pixel
	vec3 color = texture(screen_texture, SCREEN_UV).rgb;
	// Reduce the number of colors available in RGB channels.
	// For example, if pixel has red value of 0.63, it will get rounded down to nearest step set via colors_per_channel (default of 4 results in 0.5)
	vec3 quantized = floor(color * float(colors_per_channel)) / float(colors_per_channel);
	
	if (use_dithering) {
		// Get the current pixel
		vec2 frag_pos = FRAGCOORD.xy;
		// Get dithering for current pixel based on 4x4 bayer method
		float dither = bayer_dither_4x4(frag_pos);
		// Apply dithering based on colors and dither strength parameters
		vec3 dithered = floor((color + dither * dither_strength) * float(colors_per_channel)) / float(colors_per_channel);
		// Set the color for the pixel
		COLOR = vec4(dithered,1.0);
	} else {
		// Set the color for the pixel
		COLOR = vec4(quantized,1.0);
	}
}