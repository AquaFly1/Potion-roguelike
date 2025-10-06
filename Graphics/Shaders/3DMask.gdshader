shader_type canvas_item;

uniform vec4 colorForDelete: source_color;

void fragment() {
    if (COLOR == colorForDelete) {
        COLOR.a = 0.0;
    }
}