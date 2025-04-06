shader_type canvas_item;

uniform vec4 outline_color : source_color;

bool check_pixel(vec2 position, sampler2D txtr) {
	vec4 color_at_position = texture(txtr, position);
	return color_at_position.a > 0.9 && length(color_at_position.rgb) < 0.5;
}

void fragment() {
	vec2 pixel_x = vec2(TEXTURE_PIXEL_SIZE.x, 0.0);
	vec2 pixel_y = vec2(0.0, TEXTURE_PIXEL_SIZE.y);
	
	if (COLOR.a < 0.1) {
		if (
			check_pixel(UV + pixel_x, TEXTURE) ||
			check_pixel(UV - pixel_x, TEXTURE) ||
			check_pixel(UV + pixel_y, TEXTURE) ||
			check_pixel(UV - pixel_y, TEXTURE)
		) {
			COLOR = outline_color;
		}
	}
}