#version 300 es
layout(location = 0) in vec4 a_Position;
layout(location = 1) in vec4 a_Color;
out vec4 v_Color;
void main(void) {
    gl_Position = a_Position;
    if (1 == gl_VertexID) {
        v_Color = vec4(0.0, 1.0, 0.0, 1.0);
    } else {
    v_Color = a_Color;
    }
}
