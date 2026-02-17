shader_type canvas_item;

uniform vec2 mouse_pos;
uniform float radius : hint_range(0.0, 1000.0) = 200.0;
uniform float softness : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    float dist = distance(UV * vec2(1024.0, 1024.0), mouse_pos); // adjust to your resolution
    float reveal = smoothstep(radius, radius * (1.0 - softness), dist);
    COLOR.a = 1.0 - reveal;  // Transparent where revealed
}