shader_type canvas_item;

void vertex() {
	vec2 vertex_pos = VERTEX;
	VERTEX.y += vertex_pos.y * sin(TIME * vertex_pos.x * 0.05) * 0.05;
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
