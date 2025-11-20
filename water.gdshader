shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 gradient(vec4 a, vec4 b, float alpha)
{
	return alpha * a + (1.0-alpha) * b;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 coords = (FRAGCOORD.xy) / 100.0;
	float horrible_rand = sin(TIME) + tan(coords.x/100.0 + coords.y * 10.0) + sin(coords.x * 10.0 + coords.y/300.0);
	COLOR = gradient(COLOR, vec4(1), fract(sqrt(horrible_rand)));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
