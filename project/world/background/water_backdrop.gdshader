shader_type canvas_item;

uniform sampler2D gradient;

void fragment() {
	COLOR = texture(gradient, vec2(UV.y, 0.0));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
