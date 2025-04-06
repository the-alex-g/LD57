shader_type canvas_item;

uniform vec4 outline_color : source_color;

bool check_pixel(vec2 position, sampler2D txtr) {
	vec4 color_at_position = texture(txtr, position);
	if (
		position.x > 1.0 || position.x < 0.0 ||
		position.y < 0.0 || position.y > 1.0
	) {
		return false;
	} else {
		return color_at_position.a > 0.9 && length(color_at_position.rgb) < 0.5;
	}
}

void fragment() {
	float pixel_size = TEXTURE_PIXEL_SIZE.x;
	
	if (COLOR.a < 0.1) {
		if (
			check_pixel(UV + vec2(pixel_size, 0.0), TEXTURE) ||
			check_pixel(UV + vec2(-pixel_size, 0.0), TEXTURE) ||
			check_pixel(UV + vec2(0.0, pixel_size), TEXTURE) ||
			check_pixel(UV + vec2(0.0, -pixel_size), TEXTURE)
		) {
			COLOR = outline_color;
		}
	}
}