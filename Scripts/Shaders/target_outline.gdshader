shader_type spatial;

// Appears in front, unshaded
render_mode cull_front, unshaded;

uniform vec4 outline_color : source_color;
uniform float outline_width = 3.0;

void vertex() {
	// Calculate the object's position
	vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	// Calculate the object's normal
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);

	// Calculate the offset
	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * outline_width * 2.0;

	// Use the offset to target only the outline of the object
	clip_position.xy += offset;

	POSITION = clip_position;
}

void fragment() {
	// Set the albedo of each to the outline color
	ALBEDO = outline_color.rgb;
	// Apply alpha if necessary
	if (outline_color.a < 1.0) {
		ALPHA = outline_color.a;
	}
}