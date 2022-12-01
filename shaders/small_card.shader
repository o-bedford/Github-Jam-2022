shader_type canvas_item;

const float ratio = 0.15;

vec2 deform(vec2 coord) {
	coord.x -= 10.;
	if (coord.x < 0.) {
		coord.x -= (coord.y)*ratio;
	}
	else {
		coord.x += (coord.y)*ratio;
	}
	coord.x += 20.;
	return coord;
}

void vertex() {
	VERTEX = deform(VERTEX);
}