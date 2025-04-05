shader_type canvas_item;

uniform sampler2D image;

float wave(float magnitude, float wavelength, float offset) {
	return sin(TIME * wavelength + offset) * magnitude;
}

void fragment() {
	vec2 offset_coords = UV;
	float wave = wave(0.125, 1.0, UV.y) - wave(0.25, 3.0, UV.y);
	offset_coords.x += wave * (1.0 - UV.y);
	offset_coords.x = offset_coords.x * 2.0 - 0.5;
	if (offset_coords.x > 0.0 && offset_coords.x < 1.0) {
		COLOR = texture(image, offset_coords);
	} else {
		COLOR = vec4(0.0);
	}
}